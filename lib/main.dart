import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_books/screens/books_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Livros',
      home: BooksList(),
    );
  }
}