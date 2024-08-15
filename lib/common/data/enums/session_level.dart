enum SessionLevel {
  beginner,
  intermediate,
  advanced;

  String get name {
    switch (this) {
      case SessionLevel.beginner:
        return 'Introductory and overview';
      case SessionLevel.intermediate:
        return 'Intermediate';
      case SessionLevel.advanced:
        return 'Advanced';
    }
  }

  static SessionLevel fromValue(String value) {
    switch (value) {
      case 'Introductory and overview':
        return SessionLevel.beginner;
      case 'Intermediate':
        return SessionLevel.intermediate;
      case 'Advanced':
        return SessionLevel.advanced;
      default:
        throw Exception('Unknown session level: $value');
    }
  }
}
