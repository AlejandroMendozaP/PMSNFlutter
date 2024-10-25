import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/sales_database.dart';

class AddItemModal extends StatefulWidget {
  final Function onItemAdded;

  AddItemModal({required this.onItemAdded});

  @override
  _AddItemModalState createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  late SalesDatabase db;
  List<Map<String, dynamic>> categories = [];
  int? selectedCategory;
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = SalesDatabase();
    loadCategories(); // Cargar las categorías de la base de datos
  }

  // Cargar las categorías desde la base de datos
  Future<void> loadCategories() async {
    var result = await db.database.then((db) => db.query('categories'));
    setState(() {
      categories = result;
    });
  }

  // Método para insertar el nuevo ítem
  Future<void> insertItem() async {
    if (selectedCategory != null && productNameController.text.isNotEmpty && priceController.text.isNotEmpty) {
      Map<String, dynamic> newItem = {
        'productName': productNameController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'categoryId': selectedCategory
      };
      await db.INSERT('items', newItem);
      widget.onItemAdded(); // Ejecutar la función después de insertar
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productNameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<int>(
            value: selectedCategory,
            hint: Text('Select Category'),
            isExpanded: true,
            items: categories.map((category) {
              return DropdownMenuItem<int>(
                value: category['idCategory'],
                child: Text(category['nameCategory']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: insertItem,
            child: Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
