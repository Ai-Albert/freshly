import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({Key? key, required this.category}) : super(key: key);
  final List<String> category;

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
    return DropdownButton<String>(
      iconEnabledColor: Colors.black,
      dropdownColor: Colors.white,
      value: currCategory!,
      style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black)),
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.montserrat(),
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
