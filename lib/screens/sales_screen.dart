import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/salesdao.dart';
import 'package:flutter_application_2/database/sales_database.dart';
import 'package:flutter_application_2/views/add_category_modal.dart';
import 'package:flutter_application_2/views/add_item_modal.dart';
import 'package:flutter_application_2/views/add_sale_modal.dart';
import 'package:badges/badges.dart' as badges;

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with SingleTickerProviderStateMixin {
  late SalesDatabase db;
  late Future<List<SalesDAO>> pendingSalesList;
  late Future<List<SalesDAO>> allSalesList;
  late Animation<double> _animation;
  late AnimationController _animationController;
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
        curve: Curves.fastOutSlowIn, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    db = SalesDatabase();
    loadSales();
    loadItemCount();
  }

  void loadSales() {
    setState(() {
      pendingSalesList = db.getPendingSales();
      allSalesList = db.SELECT_ALL_SALES();
    });
  }

  Future<void> loadItemCount() async {
    int count = await db.getItemCount();
    setState(() {
      itemCount = count;
    });
  }

  Widget buildSalesList(Future<List<SalesDAO>> salesFuture) {
    return FutureBuilder<List<SalesDAO>>(
      future: salesFuture,
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
                    IconData icon;
                    Color iconColor = Colors.black;
                    switch (sale.status) {
                      case 'completed':
                        icon = Icons.check_circle;
                        iconColor = Colors.green;
                        break;
                      case 'pending':
                        icon = Icons.hourglass_full_rounded;
                        iconColor = Colors.orange;
                        break;
                      case 'cancelled':
                        icon = Icons.cancel;
                        iconColor = Colors.redAccent;
                        break;
                      default:
                        icon = Icons.electrical_services_rounded;
                    }

                    return ListTile(
                      title: Text(sale.title),
                      subtitle: Text(sale.description),
                      trailing: Icon(icon, color: iconColor),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return AddSaleModal(
                              onSaleAdded: () => loadSales(),
                              sale: sale,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sales List'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Pending Sales"),
              Tab(text: "All Sales"),
              Tab(text: "Calendar"),
            ],
          ),
          actions: [
            badges.Badge(
              onTap: () => Navigator.pushNamed(context, '/items'),
              badgeContent: Text(
                '$itemCount',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: badges.BadgePosition.custom(start: -13, top: -10),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/items'),
                child: Transform.translate(
                  offset: Offset(-5, -5),
                  child: Icon(Icons.checkroom_rounded),
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            buildSalesList(pendingSalesList), // Primera pestaña con ventas pendientes
            buildSalesList(allSalesList), // Segunda pestaña con todas las ventas
            Center(child: Text('Calendar')), // Tercera pestaña vacía
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionBubble(
          items: <Bubble>[
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
                    return AddSaleModal(onSaleAdded: () => loadSales());
                  },
                );
                _animationController.reverse();
              },
            ),
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
                        Navigator.pop(context);
                      },
                    );
                  },
                );
                _animationController.reverse();
              },
            ),
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
                      onCategoryAdded: () {},
                    );
                  },
                );
                _animationController.reverse();
              },
            ),
          ],
          animation: _animation,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.white,
          iconData: Icons.add,
          backGroundColor: Colors.blue,
        ),
      ),
    );
  }
}
