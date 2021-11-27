import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//import 'package:fluent_appbar/fluent_appbar.dart';
import 'package:flutter/material.dart';
import 'package:freshly/custom_widgets/show_alert_dialog.dart';
import 'package:freshly/custom_widgets/show_exception_alert_dialog.dart';
import 'package:freshly/screens/add_item.dart';
import 'package:freshly/screens/favorites.dart';
import 'package:freshly/screens/groceries.dart';
import 'package:freshly/services/auth.dart';
import 'package:freshly/services/database.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
    _children = [Groceries(scrollController: scrollController), Container(), Favorites(scrollController: scrollController)];
  }

  // Signs out using Firebase
  Future _signOut() async {
    try {
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Asks user to sign out
  Future _confirmSignOut(BuildContext context) async {
    final request = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to log out?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Log out',
    );
    if (request) {
      _signOut();
    }
  }

  // Deletes account and associated data
  Future _accountDelete() async {
    try {
      await Provider.of<Database>(context, listen: false).deleteData();
      await Provider.of<AuthBase>(context, listen: false).deleteAccount();
      Navigator.of(context).pop();
    } catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Operation failed",
        exception: Exception("Try signing out and in again to do this."),
      );
    }
  }

  // Asks user to confirm account and data deletion
  Future _confirmAccountDelete(BuildContext context) async {
    final request = await showAlertDialog(
      context,
      title: 'Delete Account',
      content: 'Are you sure you want to delete your account and data?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    );
    if (request) {
      _accountDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _appBarTitles[_currentIndex],
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),*/

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
