// ignore_for_file: prefer_const_constructors

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/salesdao.dart'; // Importa tu SalesDAO
import 'package:flutter_application_2/database/sales_database.dart';
import 'package:flutter_application_2/views/add_category_modal.dart';
import 'package:flutter_application_2/views/add_item_modal.dart';
import 'package:flutter_application_2/views/add_sale_modal.dart'; // Importa tu SalesDatabase
import 'package:badges/badges.dart' as badges;

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with SingleTickerProviderStateMixin {
  late SalesDatabase db;
  late Future<List<SalesDAO>> salesList;
  late Animation<double> _animation;
  late AnimationController _animationController;
  int itemCount = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
        curve: Curves.fastOutSlowIn, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    db = SalesDatabase();
    loadSales();
    loadItemCount();
  }

  // Cargar las ventas de la base de datos
  void loadSales() {
    setState(() {
      salesList = db.SELECT_ALL_SALES(); //db.getPendingSales();
    });
  }

  // Método para cargar la cantidad de items
  Future<void> loadItemCount() async {
    int count = await db.getItemCount();
    setState(() {
      itemCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sales List'),
          actions: [
            badges.Badge(
              onTap: () {
                Navigator.pushNamed(context, '/items');
              },
              badgeContent: Text(
                '$itemCount',
                style: TextStyle(color: Colors.white, fontSize: 10), // Ajusta el tamaño del texto
              ),
              position: badges.BadgePosition.custom(start: -13, top: -10), // posición del badge
              badgeStyle: badges.BadgeStyle(
                //padding: EdgeInsets.all(5), // tamaño del badge
                badgeColor: Colors.red,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/items');
                },
                child: Transform.translate(
                offset: Offset(-5,-5),
                child: Icon(Icons.checkroom_rounded, ),
              ),
              )
            ),
          ],
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
                        String status = sale.status;

                        // Selección del ícono basado en el status
                        IconData icon;
                        Color iconColor = Colors.black;
                        if (status == 'completed') {
                          icon = Icons.check_circle;
                          iconColor = Colors.green;
                        } else if (status == 'pending') {
                          icon = Icons.hourglass_full_rounded;
                          iconColor = Colors.orange;
                        } else if (status == 'cancelled') {
                          icon = Icons.cancel;
                          iconColor = Colors.redAccent;
                        } else {
                          icon = Icons
                              .electrical_services_rounded; // Ícono por defecto
                        }

                        return ListTile(
                          title: Text(sale.title),
                          subtitle: Text(sale.description),
                          trailing: Icon(icon,
                              color:
                                  iconColor), // Usamos el ícono según el status
                          onTap: () {
                            // Abre el modal para editar con los datos actuales
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return AddSaleModal(
                                  onSaleAdded: () => loadSales(),
                                  sale:
                                      sale, // Pasar la venta seleccionada para editar
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Sale",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.shopping_bag_rounded,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return AddSaleModal(
                      onSaleAdded: () =>
                          loadSales(), // Recargar la lista de ventas
                    );
                  },
                );
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title: "Item",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.checkroom_rounded,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return AddItemModal(
                      onItemAdded: () {
                        loadItemCount();
                        Navigator.pop(
                            context); // Cierra el modal después de agregar
                      },
                    );
                  },
                );
                _animationController.reverse();
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Category",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.category,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return AddCategoryModal(
                      onCategoryAdded: () {
                        // Aquí puedes cargar de nuevo las categorías si lo necesitas
                      },
                    );
                  },
                );
                _animationController.reverse();
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          // Floating Action button Icon color
          iconColor: Colors.white,

          // Flaoting Action button Icon
          iconData: Icons.add,
          backGroundColor: Colors.blue,
        ));
  }
}
