class Book {
  int? _id;
  String _title;
  String _genre;
  String _author;

  Book({required String title, required String genre, required String author})
      : _title = title,
        _genre = genre,
        _author = author;

  int? get id => _id;

  String get title => _title;

  String get genre => _genre;

  String get author => _author;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set genre(String newGenre) {
    if (newGenre.length <= 255) {
      _genre = newGenre;
    }
  }

  set author(String newAuthor) {
    _author = newAuthor;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["genre"] = _genre;
    map["author"] = _author;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Book.fromMap(dynamic o)
      : _id = o["id"],
        _title = o["title"],
        _genre = o['genre'],
        _author = o['author'];
}
