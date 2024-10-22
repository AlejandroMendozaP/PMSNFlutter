import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/provider/test_provider.dart';
import 'package:flutter_application_2/screens/profile_screen.dart';
import 'package:flutter_application_2/settings/colors_settings.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:flutter_application_2/settings/theme_settings.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {

    final testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSettings.navColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_chart)),
          GestureDetector(
              onTap: () {},
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Image.asset('assets/arana.png')))
        ],
      ),
      body: Builder(builder: (context) {
        switch (index) {
          case 0:
            return const Center(
              child: Text('Home Screen'),
            );
          case 1:
            return const ProfileScreen();
          case 2:
            return const Center(
              child: Text('Exit Screen'),
            );
          default:
            return const ProfileScreen();
        }
      }),
      //endDrawer: const Drawer(),
      drawer: myDrawer(testProvider),
      /*drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
              color: Colors.blue,
            ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Personajes'),
              onTap: () {
                Navigator.pushNamed(context, "/personajes");
              },
            ),
          ],
        ),
      ),*/
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.exit_to_app, title: 'Exit'),
        ],
        onTap: (int i) => setState(() {
          index = i;
        }),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        type: ExpandableFabType.up,
        children: [
          FloatingActionButton.small(
              heroTag: "btn1",
              onPressed: () {
                GlobalValues.selectedTheme.value="Light";
              },
              child: const Icon(Icons.light_mode)),
          FloatingActionButton.small(
            heroTag: "btn2",
              onPressed: () {
                GlobalValues.selectedTheme.value="Dark";
                //GlobalValues.banThemeDark.value = true;
              },
              child: const Icon(Icons.dark_mode))
        ],
      ),
    );
  }

  Widget myDrawer(TestProvider testProvider){
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            accountName: Text(testProvider.name),
            accountEmail: Text('20030741@itcelaya.edu.mx')
            ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, "/movies"),
            title: const Text('MovieScreen'),
            subtitle: const Text('Database'),
            leading: const Icon(Icons.movie),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, "/personajes"),
            title: const Text('Personajes'),
            subtitle: const Text('spiderman'),
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, "/popularmovies"),
            title: const Text('Popular Movies'),
            subtitle: const Text('API'),
            leading: const Icon(Icons.movie_rounded),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, "/sales"),
            title: const Text('Sales'),
            subtitle: const Text('DB'),
            leading: const Icon(Icons.shopping_bag),
            trailing: const Icon(Icons.chevron_right),
          ),
        ]
        ),
    );
  }

}
