import 'dart:typed_data';

import 'package:flutter_svg/flutter_svg.dart';

/// Loads a network SVG and rewrites its `<style>` class rules into plain
/// attributes before flutter_svg parses it.
///
/// flutter_svg ignores `<style>` blocks and `class` attributes. Illustrator
/// exports (common for sponsor and organiser logos) set every fill and
/// clip-path through classes like `.cls-1 { fill: #27364e; }`, so without
/// this they render as solid black shapes or unclipped images.
class CssInliningSvgLoader extends SvgNetworkLoader {
  const CssInliningSvgLoader(super.url);

  @override
  String provideSvg(Uint8List? message) =>
      inlineSvgClassStyles(super.provideSvg(message));

  @override
  int get hashCode => Object.hash(runtimeType, super.hashCode);

  @override
  bool operator ==(Object other) =>
      other is CssInliningSvgLoader && super == other;
}

final _styleBlock = RegExp(r'<style\b[^>]*>([\s\S]*?)</style>');
final _cssComment = RegExp(r'/\*[\s\S]*?\*/');
final _cssRule = RegExp(r'([^{}]+)\{([^{}]*)\}');
final _openTag = RegExp(r'<([A-Za-z][\w:.-]*)(\s[^<>]*?)?(/?)>');
final _classAttr = RegExp(r'''\sclass\s*=\s*("([^"]*)"|'([^']*)')''');

/// Replaces `class="…"` on each element with the declarations its classes
/// get from the SVG's `<style>` blocks, and drops the blocks. Only plain
/// class selectors (`.a`, `.a, .b`) are applied; rules are applied in
/// stylesheet order and override a presentation attribute of the same name,
/// as CSS does. Returns [svg] unchanged when it has no class rules.
String inlineSvgClassStyles(String svg) {
  final rules = <String, Map<String, String>>{};
  for (final block in _styleBlock.allMatches(svg)) {
    final css = block.group(1)!.replaceAll(_cssComment, '');
    for (final rule in _cssRule.allMatches(css)) {
      final declarations = <String, String>{};
      for (final declaration in rule.group(2)!.split(';')) {
        final colon = declaration.indexOf(':');
        if (colon <= 0) continue;
        declarations[declaration.substring(0, colon).trim()] = declaration
            .substring(colon + 1)
            .trim();
      }
      for (final selector in rule.group(1)!.split(',')) {
        final name = selector.trim();
        if (!RegExp(r'^\.[\w-]+$').hasMatch(name)) continue;
        (rules[name.substring(1)] ??= {}).addAll(declarations);
      }
    }
  }
  if (rules.isEmpty) return svg;

  return svg.replaceAll(_styleBlock, '').replaceAllMapped(_openTag, (tag) {
    var attributes = tag.group(2) ?? '';
    final classMatch = _classAttr.firstMatch(attributes);
    if (classMatch == null) return tag.group(0)!;

    final declarations = <String, String>{};
    final classes = (classMatch.group(2) ?? classMatch.group(3)!).split(
      RegExp(r'\s+'),
    );
    for (final entry in rules.entries) {
      if (classes.contains(entry.key)) declarations.addAll(entry.value);
    }
    attributes = attributes.replaceFirst(classMatch.group(0)!, '');
    for (final MapEntry(:key, :value) in declarations.entries) {
      attributes =
          '${attributes.replaceAll(RegExp('\\s${RegExp.escape(key)}\\s*=\\s*("[^"]*"|\'[^\']*\')'), '')}'
          ' $key="${value.replaceAll('"', '&quot;')}"';
    }
    return '<${tag.group(1)}$attributes${tag.group(3)}>';
  });
}
