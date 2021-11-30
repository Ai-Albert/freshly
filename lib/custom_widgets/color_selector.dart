import 'package:flutter/material.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({Key? key, required this.darkMode, required this.color}) : super(key: key);

  final List<bool> darkMode;
  final List<String> color;

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Map<String, String> colorMap1 = {
    'Red': '0xFFE53935',
    'Orange': '0xFFE64A19',
    'Yellow': '0xFFFDD835',
    'Green': '0xFF43A047',
    'Teal': '0xFF009688',
    'Cyan': '0xFF00ACC1',
    'Blue': '0xFF0288D1',
    'Purple': '0xFF8E24AA',
    'Pink': '0xFFD81B60',
  };
  Map<String, String> colorMap2 = {
    '0xFFE53935': 'Red',
    '0xFFE64A19': 'Orange',
    '0xFFFDD835': 'Yellow',
    '0xFF43A047': 'Green',
    '0xFF009688': 'Teal',
    '0xFF00ACC1': 'Cyan',
    '0xFF0288D1': 'Blue',
    '0xFF8E24AA': 'Purple',
    '0xFFD81B60': 'Pink',
  };
  late String? currColor;

  @override
  void initState() {
    super.initState();
    currColor = colorMap2[widget.color[0]];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle darkStyle = const TextStyle(color: Colors.white);
    TextStyle lightStyle = const TextStyle(color: Colors.black);
    if (widget.darkMode[0]) {
      return _buildDropdownButton(darkStyle);
    }
    return _buildDropdownButton(lightStyle);
  }

  Widget _buildDropdownButton(TextStyle style) {
    return DropdownButton<String>(
      iconEnabledColor: widget.darkMode[0] ? Colors.white : Colors.black,
      dropdownColor: widget.darkMode[0] ? Colors.grey[900] : Colors.white,
      value: currColor!,
      style: style,
      items: <String>[
        'Red',
        'Orange',
        'Yellow',
        'Green',
        'Teal',
        'Cyan',
        'Blue',
        'Purple',
        'Pink',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          currColor = value;
          widget.color[0] = colorMap1[value!]!;
          Provider.of<Database>(context, listen: false).setTheme(widget.darkMode[0], colorMap1[value]!);
        });
      },
    );
  }
}
