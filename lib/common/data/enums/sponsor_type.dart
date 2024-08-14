enum SponsorType {
  platinum,
  swag,
  startup,
  venue;

  static SponsorType fromValue(String value) {
    switch (value) {
      case 'platinum':
        return SponsorType.platinum;
      case 'swag':
        return SponsorType.swag;
      case 'startup':
        return SponsorType.startup;
      case 'venue':
        return SponsorType.venue;
      default:
        throw Exception('Unknown sponsor type: $value');
    }
  }
}
