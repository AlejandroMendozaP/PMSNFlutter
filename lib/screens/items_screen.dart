import 'package:flutter/material.dart';
import 'package:flutter_application_2/database/sales_database.dart';
import 'package:group_list_view/group_list_view.dart';

class ItemsScreen extends StatefulWidget {
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late SalesDatabase db;
  late Future<Map<String, List<Map<String, dynamic>>>> categorizedItems;

  @override
  void initState() {
    super.initState();
    db = SalesDatabase();
    loadItems();
  }

  void loadItems() {
    setState(() {
      categorizedItems = db.getItemsGroupedByCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Items List")),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: categorizedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items available'));
          } else {
            var groupedItems = snapshot.data!;
            return GroupListView(
              sectionsCount: groupedItems.keys.length,
              countOfItemInSection: (int section) {
                String category = groupedItems.keys.elementAt(section);
                return groupedItems[category]?.length ?? 0;
              },
              itemBuilder: (context, indexPath) {
                String category = groupedItems.keys.elementAt(indexPath.section);
                var item = groupedItems[category]![indexPath.index];

                return ListTile(
                  title: Text(item['productName']),
                  subtitle: Text("Price: \$${item['price']}"),
                );
              },
              groupHeaderBuilder: (BuildContext context, int section) {
                String category = groupedItems.keys.elementAt(section);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              },
              //separatorBuilder: (context, indexPath) => Divider(),
              sectionSeparatorBuilder: (context, section) => Divider(
                thickness: 1,
                color: const Color.fromARGB(255, 179, 179, 179),
              ),
            );
          }
        },
      ),
    );
  }
}
