class Book {
  String? _id;
  String _title;
  String _genre;
  String _author;

  Book({required String title, required String genre, required String author})
      : _title = title,
        _genre = genre,
        _author = author;

  String? get id => _id;

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

  Book.fromMap(Map<String, dynamic> data, String id)
      : _id = id,
        _title = data["title"],
        _genre = data['genre'],
        _author = data['author'];
}
