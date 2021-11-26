import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluent_appbar/fluent_appbar.dart';
import 'package:flutter/material.dart';
import 'package:freshly/custom_widgets/show_alert_dialog.dart';
import 'package:freshly/custom_widgets/show_exception_alert_dialog.dart';
import 'package:freshly/screens/favorites.dart';
import 'package:freshly/screens/groceries.dart';
import 'package:freshly/services/auth.dart';
import 'package:freshly/services/database.dart';
import 'package:freshly/sign_in/sign_in.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScrollController scrollController = ScrollController();

  // Controls variable elements of the basic structure of the app
  int _currentIndex = 0;
  final List<Widget> _children = [Groceries(),Favorites()];
  final List<String> _appBarTitles = ['Groceries', 'Favorites'];
/*
  AnimatedIconButton(
  icons: const [
  AnimatedIconItem(
  icon: Icon(Icons.favorite_border, color: Colors.black,),
  ),
  AnimatedIconItem(
  icon: Icon(Icons.favorite, color: Colors.red),
  ),
  ],
  onPressed: () => print("outer"),
  )];
*/
  @override
  void initState() {
    super.initState();
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
          FluentAppBar(titleText: _appBarTitles[_currentIndex], scrollController: scrollController),
        ],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 250),
        color: Colors.white,
        backgroundColor: Colors.red,
        items: const [
          Icon(Icons.local_dining),
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
