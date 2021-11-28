import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:freshly/screens/add_item.dart';
import 'package:freshly/screens/favorites.dart';
import 'package:freshly/screens/groceries.dart';
import 'package:freshly/screens/settings.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';
import 'package:freshly/custom_widgets/custom_appbar.dart';

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScrollController scrollController = ScrollController();

  // Controls variable elements of the basic structure of the app
  int _currentIndex = 0;
  late final List<Widget> _children;
  final List<String> _appBarTitles = ['Groceries', 'Settings', 'Favorites'];

  @override
  void initState() {
    super.initState();
    _children = [
      Groceries(scrollController: scrollController),
      Settings(context: context),
      Favorites(scrollController: scrollController),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _children[_currentIndex],
          FluentAppBar(
            scrollController: scrollController,
            titleText: _appBarTitles[_currentIndex],
            appBarColor: Colors.white,
          ),
        ],
      ),

      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          final database = Provider.of<Database>(context, listen: false);
          AddItem.show(context, database: database);
        }
      ) : null,

      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 250),
        color: Colors.white,
        backgroundColor: Colors.red,
        items: const [
          Icon(Icons.local_dining),
          Icon(Icons.settings),
          Icon(Icons.favorite),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
