import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:freshly/screens/add_item.dart';
import 'package:freshly/screens/favorites.dart';
import 'package:freshly/screens/groceries.dart';
import 'package:freshly/screens/settings.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';
import 'custom_appbar.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({
    Key? key,
    required this.darkMode,
    required this.accentColor,
    required this.fab,
  }) : super(key: key);

  final bool darkMode;
  final String accentColor;
  final Widget fab;

  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {

  ScrollController scrollController = ScrollController();

  // Controls variable elements of the basic structure of the app
  late int _currentIndex = 0;
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
      backgroundColor: widget.darkMode ? Colors.black : Colors.white,

      body: Stack(
        children: [
          _children[_currentIndex],
          FluentAppBar(
            scrollController: scrollController,
            titleText: _appBarTitles[_currentIndex],
            titleColor: widget.darkMode ? Colors.white : Colors.black,
            appBarColor: widget.darkMode ? Colors.black : Colors.white,
          ),
          widget.fab,
        ],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 250),
        color: widget.darkMode ? Colors.black : Colors.white,
        backgroundColor: Color(int.parse(widget.accentColor)),
        buttonBackgroundColor: widget.darkMode ? Colors.grey[900] : Colors.grey[50],
        items: [
          Icon(Icons.local_dining, color: widget.darkMode ? Colors.white : Colors.black),
          Icon(Icons.settings, color: widget.darkMode ? Colors.white : Colors.black),
          Icon(Icons.favorite, color: widget.darkMode ? Colors.white : Colors.black),
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
