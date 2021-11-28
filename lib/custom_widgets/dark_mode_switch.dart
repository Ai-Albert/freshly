import 'package:flutter/material.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({Key? key, required this.darkMode, required this.color}) : super(key: key);

  final List<bool> darkMode;
  final List<String> color;

  @override
  _DarkModeSwitchState createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: widget.darkMode[0],
        onChanged: (bool value) {
          setState(() {
            widget.darkMode[0] = value;
            Provider.of<Database>(context, listen: false).setTheme(value, widget.color[0]);
          });
        }
    );
  }
}
