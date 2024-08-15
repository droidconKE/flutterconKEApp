enum SessionType {
  keynote,
  codelab,
  session,
  lightningTalk,
  panelDiscussion,
  workshop;

  String get name {
    switch (this) {
      case SessionType.keynote:
        return 'Keynote';
      case SessionType.codelab:
        return 'codelab';
      case SessionType.session:
        return 'Session';
      case SessionType.lightningTalk:
        return 'Lightning talk';
      case SessionType.workshop:
        return 'Workshop';
      case SessionType.panelDiscussion:
        return 'Panel Discussion';
    }
  }
}
