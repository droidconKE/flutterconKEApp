enum BookmarkStatus {
  bookmarked,
  bookmarkRemoved;

  static BookmarkStatus fromString(String value) {
    switch (value) {
      case 'Bookmarked':
        return BookmarkStatus.bookmarked;
      case 'Bookmark Removed':
        return BookmarkStatus.bookmarkRemoved;
      default:
        throw Exception('Unknown value');
    }
  }
}
