import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:freshly/custom_widgets/color_selector.dart';
import 'package:freshly/custom_widgets/dark_mode_switch.dart';
import 'package:freshly/custom_widgets/show_alert_dialog.dart';
import 'package:freshly/custom_widgets/show_exception_alert_dialog.dart';
import 'package:freshly/models/theme_settings.dart';
import 'package:freshly/services/auth.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';

/*
    return FutureBuilder<ThemeSettings>(
      future: Provider.of<Database>(context, listen: false).getTheme(),
      builder: (BuildContext context, AsyncSnapshot<ThemeSettings> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return const CircularProgressIndicator();
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            _darkMode = snapshot.data != null ? snapshot.data!.darkMode : false;
            _accentColor = snapshot.data != null ? snapshot.data!.accentColor : '0xFFE53935';
            // Add screen below
          case ConnectionState.none:
            return const CircularProgressIndicator();
        }
      },
    );
 */

class Settings extends StatefulWidget {

  const Settings({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  late final List<bool> _darkMode = [false];
  late final List<String> _accentColor = [''];

  Future _signOut() async {
    try {
      await Provider.of<AuthBase>(widget.context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

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

  Future _accountDelete() async {
    try {
      await Provider.of<Database>(widget.context, listen: false).deleteData();
      await Provider.of<AuthBase>(widget.context, listen: false).deleteAccount();
      Navigator.of(widget.context).pop();
    } catch (e) {
      showExceptionAlertDialog(
        widget.context,
        title: "Operation failed",
        exception: Exception("Try signing out and in again to do this."),
      );
    }
  }

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
            _darkMode[0] = snapshot.data != null ? snapshot.data!.darkMode : false;
            _accentColor[0] = snapshot.data != null ? snapshot.data!.accentColor : '0xFFE53935';
            return Container(
              color: _darkMode[0] ? Colors.black : Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 24,
                  bottom: 62 + MediaQuery.of(context).padding.bottom,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5.0),
                    _darkModeSwitch(),
                    _accentColorPicker(),
                    const SizedBox(height: 150.0),
                    _logoutButton(),
                    _deleteAccountButton(),
                  ],
                ),
              ),
            );
          case ConnectionState.none:
            return Container(color: Colors.transparent);
        }
      },
    );
  }

  Widget _darkModeSwitch() {
    if (_darkMode[0]) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dark Mode:',
            style: TextStyle(color: Colors.white),
          ),
          DarkModeSwitch(darkMode: _darkMode, color: _accentColor),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dark Mode:',
          style: TextStyle(color: Colors.black),
        ),
        DarkModeSwitch(darkMode: _darkMode, color: _accentColor),
      ],
    );
  }

  Widget _accentColorPicker() {
    if (_darkMode[0]) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Accent Color:',
            style: TextStyle(color: Colors.white),
          ),
          ColorSelector(darkMode: _darkMode, color: _accentColor),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Accent Color:',
          style: TextStyle(color: Colors.black),
        ),
        ColorSelector(darkMode: _darkMode, color: _accentColor),
      ],
    );
  }

  Widget _logoutButton() {
    return AnimatedButton(
      height: 53,
      width: 200,
      text: 'Logout',
      isReverse: true,
      selectedTextColor: Colors.white,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      selectedBackgroundColor: Color(int.parse(_accentColor[0])),
      backgroundColor: Colors.black,
      borderColor: Colors.white,
      borderRadius: 15,
      borderWidth: 2,
      onPress: () => _confirmSignOut(context),
    );
  }

  Widget _deleteAccountButton() {
    return AnimatedButton(
      height: 53,
      width: 200,
      text: 'Delete Account',
      isReverse: true,
      selectedTextColor: Colors.white,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      selectedBackgroundColor: Colors.red,
      backgroundColor: Colors.black,
      borderColor: Colors.white,
      borderRadius: 15,
      borderWidth: 2,
      onPress: () => _confirmAccountDelete(context),
    );
  }
}
