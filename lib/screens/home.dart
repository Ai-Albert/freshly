import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:freshly/custom_widgets/custom_fab.dart';
import 'package:freshly/custom_widgets/home_scaffold.dart';
import 'package:freshly/models/theme_settings.dart';
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
    return FutureBuilder<ThemeSettings>(
      future: Provider.of<Database>(context, listen: false).getTheme(),
      builder: (BuildContext context, AsyncSnapshot<ThemeSettings> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return Container(color: Colors.transparent);
          case ConnectionState.waiting:
            return Container(color: Colors.transparent);
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            bool _darkMode = snapshot.data != null ? snapshot.data!.darkMode : false;
            String _accentColor = snapshot.data != null ? snapshot.data!.accentColor : '0xFFE53935';
            // return _getFab(HomeScaffold(darkMode: _darkMode, accentColor: _accentColor), _darkMode, _accentColor);
            return HomeScaffold(darkMode: _darkMode, accentColor: _accentColor, fab: _getFab(_darkMode, _accentColor));
          case ConnectionState.none:
            return Container(color: Colors.transparent);
        }
      },
    );
  }

  Widget _getFab(bool darkMode, String accentColor) {
    return CustomFab(
      fabColor: Color(int.parse(accentColor)),
      items: [
        HawkFabMenuItem(
          label: 'Add Item',
          color: Color(int.parse(accentColor)),
          ontap: () {
            final database = Provider.of<Database>(context, listen: false);
            AddItem.show(context, database: database, darkMode: darkMode, accentColor: accentColor);
          },
          icon: const Icon(Icons.add),
        ),
        HawkFabMenuItem(
          label: 'Refresh Theme',
          color: Color(int.parse(accentColor)),
          ontap: () {
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      body: Container(),
    );
  }
}
