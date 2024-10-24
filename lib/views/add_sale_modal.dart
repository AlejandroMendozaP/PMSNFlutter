import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/sales_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/sales_database.dart';
import 'package:flutter_application_2/models/salesdao.dart';
import 'package:intl/intl.dart';

class AddSaleModal extends StatefulWidget {
  final Function onSaleAdded;
  final SalesDAO? sale; // Parámetro opcional para editar una venta existente

  AddSaleModal({required this.onSaleAdded, this.sale});

  @override
  _AddSaleModalState createState() => _AddSaleModalState();
}

class _AddSaleModalState extends State<AddSaleModal> {
  late SalesDatabase db;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> items = [];
  int? selectedCategory;
  int? selectedItem;
  DateTime? selectedDate;
  int quantity = 1;
  String? selectedStatus;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final List<String> statusOptions = ['pending', 'completed', 'cancelled'];

  @override
  void initState() {
    super.initState();
    db = SalesDatabase();
    loadCategories();
    // Si se está editando una venta, prellenar los datos
    if (widget.sale != null) {
      populateFields(widget.sale!);
    }
  }

  // Prellenar los campos con los datos de la venta existente
  void populateFields(SalesDAO sale) async {
  titleController.text = sale.title;
  descriptionController.text = sale.description;
  selectedDate = DateTime.parse(sale.date);
  dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
  selectedStatus = sale.status;
  quantity = sale.quantity;
  selectedItem = sale.idItem;

  // Obtener la categoría del ítem
  var itemData = await db.database.then(
    (db) => db.query('items', where: 'idItem = ?', whereArgs: [sale.idItem]),
  );

  if (itemData.isNotEmpty) {
    selectedCategory = itemData.first['categoryId'] as int?;
    loadItems(selectedCategory!); // Cargar los ítems de la categoría
    setState(() {});
  }
}


  // Cargar las categorías de la base de datos
  Future<void> loadCategories() async {
    var result = await db.database.then((db) => db.query('categories'));
    setState(() {
      categories = result;
    });
  }

  // Cargar los ítems de la categoría seleccionada
  Future<void> loadItems(int categoryId) async {
    var result = await db.database.then(
      (db) => db.query('items', where: 'categoryId = ?', whereArgs: [categoryId]),
    );
    setState(() {
      items = result;
    });
  }

  // Mostrar el DatePicker para seleccionar una fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Guardar o actualizar la venta en la base de datos
  Future<void> saveSale() async {
    if (selectedItem != null && selectedDate != null && selectedStatus != null) {
      Map<String, dynamic> saleData = {
        'title': titleController.text,
        'description': descriptionController.text,
        'date': selectedDate!.toIso8601String().substring(0, 10),
        'idItem': selectedItem,
        'quantity': quantity,
        'status': selectedStatus,
      };

      if (widget.sale == null) {
        // Insertar nueva venta
        await db.INSERT('sales', saleData);
      } else {
        // Actualizar la venta existente
        if (widget.sale?.idSale != null) {
          await db.UPDATE('sales', saleData, 'idSale', widget.sale!.idSale!);
        } else {
          // Manejar el caso en que idSale sea nulo (si aplica)
          print('El id de la venta es nulo.');
        }

      }

      widget.onSaleAdded(); // Notificar que se agregó o actualizó una venta
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Category'),
              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category['idCategory'],
                  child: Text(category['nameCategory']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  loadItems(value!); // Cargar ítems al seleccionar una categoría
                });
              },
              value: selectedCategory, // Preseleccionar la categoría
            ),

            SizedBox(height: 16),
            //if (items.isNotEmpty)
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Item'),
                items: items.map((item) {
                  return DropdownMenuItem<int>(
                    value: item['idItem'],
                    child: Text(item['productName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
                value: selectedItem, // Preseleccionar el ítem
              ),

            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2030)
                );

                if(picked != null){
                  String formatDate = DateFormat('dd-MM-yyyy').format(picked);
                  dateController.text = formatDate;
                  selectedDate = picked;
                  setState(() {});
                }
              },
            ),
            /*Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Select a date'
                        : 'Date: ${selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),*/
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Status'),
              items: statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
              value: selectedStatus,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Quantity: '),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveSale,
              child: Text(widget.sale == null ? 'Add Sale' : 'Update Sale'),
            ),
          ],
        ),
      ),
    );
  }
}
