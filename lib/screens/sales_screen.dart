import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/salesdao.dart'; // Importa tu SalesDAO
import 'package:flutter_application_2/database/sales_database.dart';
import 'package:flutter_application_2/views/add_sale_modal.dart'; // Importa tu SalesDatabase

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
    //addExampleCategory();
    addExampleItem();
    //addExampleSales();
    loadSales();
  }

  // Cargar las ventas de la base de datos
  void loadSales() {
    setState(() {
      salesList = db.SELECT_ALL_SALES();
    });
  }

  // Método para agregar un ítem de ejemplo
  Future<void> addExampleItem() async {
    Map<String, dynamic> newItem = {
      'productName': 'Telefono',
      'price': 19.99,
      'categoryId': 1
    };
    await db.INSERT('items', newItem);
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
                        onTap: () {
                          // Abre el modal para editar con los datos actuales
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return AddSaleModal(
                                onSaleAdded: () => loadSales(),
                                sale: sale, // Pasar la venta seleccionada para editar
                              );
                            },
                          );
                        },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 116, 156, 251),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AddSaleModal(
                onSaleAdded: () => loadSales(),  // Recargar la lista de ventas
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
