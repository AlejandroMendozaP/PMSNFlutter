import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/salesdao.dart';
import 'package:flutter_application_2/database/sales_database.dart';
import 'package:flutter_application_2/views/add_category_modal.dart';
import 'package:flutter_application_2/views/add_item_modal.dart';
import 'package:flutter_application_2/views/add_sale_modal.dart';
import 'package:badges/badges.dart' as badges;
import 'package:table_calendar/table_calendar.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with SingleTickerProviderStateMixin {
  late SalesDatabase db;
  late Future<List<SalesDAO>> pendingSalesList =
      Future.value([]); // Valor predeterminado
  late Future<List<SalesDAO>> allSalesList = Future.value([]);
  late Animation<double> _animation;
  late AnimationController _animationController;
  int itemCount = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<SalesDAO>> salesEvents = {};

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
    loadSales(); // Llamar a loadSales en initState para cargar los datos
    loadItemCount();
  }

  void loadSales() {
    db.SELECT_ALL_SALES().then((sales) {
      setState(() {
        allSalesList = Future.value(sales); // Cargar lista completa de ventas
        pendingSalesList = db.getPendingSales();
        salesEvents = _groupSalesByDate(
            sales); // Agrupar y asignar eventos al mapa de eventos
      });
    }).catchError((error) {
      print('Error loading sales: $error'); // Manejo de errores
    });
  }

  Future<void> loadItemCount() async {
    int count = await db.getItemCount();
    setState(() {
      itemCount = count;
    });
  }

  Map<DateTime, List<SalesDAO>> _groupSalesByDate(List<SalesDAO> sales) {
    Map<DateTime, List<SalesDAO>> salesMap = {};
    for (var sale in sales) {
      DateTime saleDate =
          DateTime.parse(sale.date); // Asegurar formato de fecha
      DateTime onlyDate = DateTime(saleDate.year, saleDate.month, saleDate.day);
      salesMap.putIfAbsent(onlyDate, () => []).add(sale);
    }
    return salesMap;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  setState(() {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
  });

  // Llama al método para obtener las ventas de la fecha seleccionada
  db.getSalesByDate(selectedDay).then((sales) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Text(
                "Sales on ${selectedDay.day}-${selectedDay.month}-${selectedDay.year}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              if (sales.isEmpty)
                Center(child: Text("No sales available for this day")),
              Expanded(
                child: ListView.builder(
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    return ListTile(
                      title: Text(sale.title),
                      subtitle: Text(sale.description),
                      trailing: Icon(
                        sale.status == 'completed'
                            ? Icons.check_circle
                            : sale.status == 'pending'
                                ? Icons.hourglass_full
                                : Icons.cancel,
                        color: sale.status == 'completed'
                            ? Colors.green
                            : sale.status == 'pending'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  });
}


  Widget buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color.fromARGB(255, 166, 199, 255)),
        weekendStyle: TextStyle(color: Color.fromARGB(255, 252, 141, 141))
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(color: Color.fromARGB(255, 1, 174, 38), shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: Color.fromARGB(255, 137, 197, 143), shape: BoxShape.circle)
      ),
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (day) {
        // Comprobación de eventos para el día específico
        final events =
            salesEvents[DateTime(day.year, day.month, day.day)] ?? [];
        return events;
      },
    );
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
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blueAccent,
            tabs: [
              Tab(text: "Pending Sales", icon: Icon(Icons.timer_rounded)),
              Tab(text: "All Sales", icon: Icon(Icons.all_inbox_rounded)),
              Tab(text: "Calendar", icon: Icon(Icons.calendar_month_outlined)),
            ],
          ),
          actions: [
            badges.Badge(
              onTap: () => Navigator.pushNamed(context, '/items'),
              badgeContent: Text(
                '$itemCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: badges.BadgePosition.custom(start: -13, top: -10),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/items'),
                child: Transform.translate(
                  offset: const Offset(-5, -5),
                  child: const Icon(Icons.checkroom_rounded),
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            buildSalesList(pendingSalesList), // Primera pestaña
            buildSalesList(Future.value(allSalesList)), // Segunda pestaña
            buildCalendar(),
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
          animatedIconData: AnimatedIcons.menu_close,
          backGroundColor: Colors.blue,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
