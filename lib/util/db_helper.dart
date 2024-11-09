import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();

  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  DBHelper._internal();

  factory DBHelper() {
    return instance;
  }

  Future<List<Book>> getBooks() async {
    QuerySnapshot snapshot = await booksCollection.get();
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Book.fromMap(data, doc.id);
    }).toList();
  }

  Future<void> insertBook(Book book) async {
    await booksCollection.add(book.toMap());
  }

  Future<void> deleteBook(String id) async {
    await booksCollection.doc(id).delete();
  }
}
