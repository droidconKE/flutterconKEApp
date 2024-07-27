class FlutterConValues {
  FlutterConValues({
    required this.urlScheme,
    required this.baseDomain,
  });

  final String urlScheme;
  final String baseDomain;

  String get baseUrl => '$urlScheme://$baseDomain';
}

class FlutterConConfig {
  factory FlutterConConfig({required FlutterConValues values}) {
    return _instance ??= FlutterConConfig._internal(values);
  }

  FlutterConConfig._internal(this.values);

  final FlutterConValues values;
  static FlutterConConfig? _instance;

  static FlutterConConfig? get instance => _instance;
}
