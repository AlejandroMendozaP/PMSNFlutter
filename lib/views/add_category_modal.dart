import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/sales_database.dart';

class AddCategoryModal extends StatefulWidget {
  final Function onCategoryAdded;

  AddCategoryModal({required this.onCategoryAdded});

  @override
  _AddCategoryModalState createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  late SalesDatabase db;
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = SalesDatabase();
  }

  // Método para insertar una nueva categoría en la base de datos
  Future<void> _insertCategory() async {
    if (categoryNameController.text.isNotEmpty) {
      Map<String, dynamic> newCategory = {
        'nameCategory': categoryNameController.text
      };
      await db.INSERT('categories', newCategory);
      widget.onCategoryAdded(); // Recargar las categorías después de agregar
      Navigator.pop(context); // Cerrar el modal
    }
  }

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom, // Esto ajusta el modal al teclado
      left: 16.0,
      right: 16.0,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: categoryNameController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _insertCategory,
            child: Text('Add Category'),
          ),
        ],
      ),
    ),
  );
}
}
