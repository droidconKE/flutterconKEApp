class FlutterConValues {
  FlutterConValues({
    required this.urlScheme,
    required this.baseDomain,
    required this.hiveBox,
    required this.eventSlug,
  });

  final String urlScheme;
  final String baseDomain;
  final String hiveBox;
  final String eventSlug;

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
