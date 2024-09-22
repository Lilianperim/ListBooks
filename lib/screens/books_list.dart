import 'package:flutter/material.dart';
import 'package:list_books/util/db_helper.dart';
import '../models/book.dart';
import 'form_details.dart';

class BooksList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookListState();
}

class BookListState extends State<BooksList> {
  final DBHelper helper = DBHelper();

  Future<List<Book>> _getBooks() async {
    await helper.initializeDb();
    List<Map<String, dynamic>> result = await helper.getBooks();
    return result.map((book) => Book.fromMap(book)).toList();
  }

  Future<void> _refreshBooks() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Meus livros"),
      ),
      body: FutureBuilder<List<Book>>(
        future: _getBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os livros: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum livro encontrado'));
          } else {
            List<Book> books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return _buildBookItem(context, books[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookFormOrDetailsScreen(
                isDetails: false,
                book: null,
              ),
            ),
          );
          if (result == true) {
            _refreshBooks();
          }
        },
        tooltip: "Adicionar novo livro",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, Book book) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              book.author,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Text(book.genre),
        onTap: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookFormOrDetailsScreen(
                isDetails: true,
                book: book,
              ),
            ),
          );
          if (result == true) {
            _refreshBooks();
          }
        },
      ),
    );
  }
}
