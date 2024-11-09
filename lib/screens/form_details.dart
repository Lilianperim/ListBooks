import 'package:flutter/material.dart';
import '../models/book.dart';
import '../util/db_helper.dart';

class BookFormOrDetailsScreen extends StatefulWidget {
  final bool isDetails;
  final Book? book;

  const BookFormOrDetailsScreen({
    super.key,
    required this.isDetails,
    this.book,
  });

  @override
  _BookFormOrDetailsScreenState createState() =>
      _BookFormOrDetailsScreenState();
}

class _BookFormOrDetailsScreenState extends State<BookFormOrDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isDetails && widget.book != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    _titleController.text = widget.book!.title;
    _genreController.text = widget.book!.genre;
    _authorController.text = widget.book!.author;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              _buildTextFormField(
                controller: _titleController,
                label: 'Título',
                enabled: !widget.isDetails,
                validator: (value) => _validateField(value, 'Título'),
              ),
              _buildTextFormField(
                controller: _genreController,
                label: 'Gênero',
                enabled: !widget.isDetails,
                validator: (value) => _validateField(value, 'Gênero'),
              ),
              _buildTextFormField(
                controller: _authorController,
                label: 'Autor',
                enabled: !widget.isDetails,
                validator: (value) => _validateField(value, 'Autor'),
              ),
              const SizedBox(height: 20),
              if (!widget.isDetails) _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.isDetails ? 'Detalhes' : 'Adicionar Livro'),
      actions: widget.isDetails
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _showDeleteConfirmationDialog,
              ),
            ]
          : null,
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      enabled: enabled,
      validator: validator,
    );
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Preencha o $fieldName';
    }
    return null;
  }

  ElevatedButton _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        _validateAndSave();
      },
      child: const Text('Salvar'),
    );
  }

  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _saveBook();
    } else {
      _showSnackBar('Por favor, corrija os erros antes de salvar.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação de Exclusão"),
          content: const Text("Tem certeza que deseja excluir este livro?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Confirmar"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deleteBook();
    }
  }

  void _deleteBook() async {
    if (widget.book != null) {
      DBHelper helper = DBHelper();
      try {
        await helper.deleteBook(widget.book!.id!);
        Navigator.pop(context, true);
        _showSnackBar('Livro excluído com sucesso!');
      } catch (e) {
        _showSnackBar('Erro ao excluir o livro.');
      }
    }
  }

  void _saveBook() async {
    Book newBook = Book(
      title: _titleController.text,
      genre: _genreController.text,
      author: _authorController.text,
    );

    DBHelper helper = DBHelper();
    try {
      await helper.insertBook(newBook);
      Navigator.pop(context, true);
      _showSnackBar('Livro salvo com sucesso!');
    } catch (e) {
      _showSnackBar('Erro ao salvar o livro.');
    }
  }
}
