import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {

  const CategorySelector({Key? key, required this.category, required this.darkMode}) : super(key: key);

  final List<String> category;
  final bool darkMode;

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<String> categories = [
    'Fruits',
    'Vegetables',
    'Meats',
    'Dairy',
    'Grains',
    'Bakery',
    'Snacks',
    'Drinks',
    'Condiments',
    'Misc',
  ];
  late String? currCategory;

  @override
  void initState() {
    super.initState();
    currCategory = widget.category[0] != '' ? widget.category[0] : categories[0];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.darkMode) {
      return DropdownButton<String>(
        iconEnabledColor: widget.darkMode ? Colors.white : Colors.black,
        dropdownColor: widget.darkMode ? Colors.black : Colors.white,
        value: currCategory!,
        style: const TextStyle(color: Colors.white),
        items: categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            currCategory = value;
            widget.category[0] = value!;
          });
        },
      );
    }
    return DropdownButton<String>(
      iconEnabledColor: widget.darkMode ? Colors.white : Colors.black,
      dropdownColor: widget.darkMode ? Colors.black : Colors.white,
      value: currCategory!,
      style: const TextStyle(color: Colors.black),
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          currCategory = value;
          widget.category[0] = value!;
        });
      },
    );
  }
}
