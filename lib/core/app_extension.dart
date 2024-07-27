import 'package:flutter/material.dart';

extension StringExtension on String {
  String get toCapital {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension IntegetExtension on int? {
  bool get success {
    if (this == 200 || this == 201 || this == 204) {
      return true;
    }
    return false;
  }
}

extension GeneralExtension<T> on T {
  bool get isEnum {
    final split = toString().split('.');
    return split.length > 1 && split[0] == runtimeType.toString();
  }

  String get getEnumString => toString().split('.').last.toCapital;
}

extension MapExtension on Map {
  String get format {
    if (isEmpty) {
      return '';
    } else {
      final firstKey = entries.first.key;
      final mapValues = entries.first.value;
      return '?$firstKey=$mapValues';
    }
  }
}

//Helper functions
void pop(BuildContext context, int returnedLevel) {
  for (var i = 0; i < returnedLevel; ++i) {
    Navigator.pop(context, true);
  }
}
