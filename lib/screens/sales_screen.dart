import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/salesdao.dart'; // Importa tu SalesDAO
import 'package:flutter_application_2/database/sales_database.dart'; // Importa tu SalesDatabase

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late SalesDatabase db;
  late Future<List<SalesDAO>> salesList;

  @override
  void initState() {
    super.initState();
    db = SalesDatabase();
    addExampleCategory();
    addExampleItem();
    addExampleSales();
    loadSales();
  }

  // Cargar las ventas de la base de datos
  void loadSales() {
    setState(() {
      salesList = db.SELECT_ALL_SALES();
    });
  }

  // Método para agregar una categoría de ejemplo
  Future<void> addExampleCategory() async {
    Map<String, dynamic> newCategory = {
      'nameCategory': 'Example Category'
    };
    await db.INSERT('categories', newCategory);
  }

  // Método para agregar un ítem de ejemplo
  Future<void> addExampleItem() async {
    Map<String, dynamic> newItem = {
      'productName': 'Example Item',
      'price': 19.99,
      'categoryId': 1  // Asegúrate de que este ID coincida con una categoría existente
    };
    await db.INSERT('items', newItem);
  }

  // Método para agregar una venta de ejemplo
  Future<void> addExampleSales() async {
    // Asegurarse de que existan categorías e ítems antes de agregar una venta
    await addExampleCategory();
    await addExampleItem();

    Map<String, dynamic> newSale = {
      'title': 'Example Sale',
      'description': 'This is an example sale.',
      'date': '2024-10-21',
      'idItem': 1,  // Asegúrate de que este item exista en la base de datos
      'quantity': 2,
      'status': 'pending'
    };
    await db.INSERT('sales', newSale);

    // Recarga la lista de ventas
    loadSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales List'),
      ),
      body: FutureBuilder<List<SalesDAO>>(
        future: salesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading sales'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sales available'));
          } else {
            var sales = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      SalesDAO sale = sales[index];
                      return ListTile(
                        title: Text(sale.title),
                        subtitle: Text(sale.description),
                        trailing: Text(sale.status),
                      );
                    },
                    childCount: sales.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
