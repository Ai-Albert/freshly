import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:freshly/custom_widgets/category_selector.dart';
import 'package:freshly/models/food_item.dart';
import 'package:freshly/custom_widgets/show_exception_alert_dialog.dart';
import 'package:freshly/services/database.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddItem extends StatefulWidget {

  // The FoodItem is passed into show() if editing an existing item, otherwise item is null
  const AddItem({Key? key, required this.database, this.item, required this.darkMode, required this.accentColor}) : super(key: key);

  final Database database;
  final FoodItem? item;
  final bool darkMode;
  final String accentColor;

  /* We use this function to go to this page because we need to do MaterialPageRoute
   * for onPressed since onPressed requires a function and AddJobPage is a Widget
   */
  static Future<void> show(
      BuildContext context, {
        required Database database,
        FoodItem? item,
        required bool darkMode,
        required String accentColor,
      }
  ) async {
    showBarModalBottomSheet(
      context: context,
      builder: (context) => AddItem(database: database, item: item, darkMode: darkMode, accentColor: accentColor),
      elevation: 100,
      barrierColor: Colors.black45,
    );
  }

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddItem> {

  // All the variables we need to make an item
  late String _itemName;
  late DateTime _expiryDate;
  late final List<String> _category = [''];

  // Setting up initial values in the form
  @override
  void initState() {
    super.initState();

    _itemName = widget.item?.name ?? '';

    final expiry = widget.item?.expiryDate ?? DateTime.now();
    _expiryDate = DateTime(expiry.year, expiry.month, expiry.day);

    _category[0] = widget.item?.category ?? '';
  }

  // Creating a FoodItem object from the info input into the form so far
  FoodItem _itemFromState() {
    return FoodItem(
      id: widget.item?.id ?? documentIdFromCurrentDate(),
      name: _itemName,
      expiryDate: _expiryDate,
      category: _category[0],
      favorite: widget.item?.favorite ?? false,
    );
  }

  // Setting the Task and popping out back to the Fireplace page
  Future<void> _setItemAndDismiss(BuildContext context) async {
    try {
      final FoodItem item = _itemFromState();
      if (item.name == '') {
        throw const FormatException('EMPTY_NAME');
      }

      await widget.database.setFoodItem(item);
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    } on FormatException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Please enter a task name',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: widget.darkMode ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30.0),
                _buildName(),
                const SizedBox(height: 30.0),
                _buildCategory(),
                const SizedBox(height: 30.0),
                _buildExpiryDate(),
                const SizedBox(height: 50.0),
                _addButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    if (widget.darkMode) {
      return TextField(
        decoration: InputDecoration(
          labelText: 'Item Name',
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.darkMode ? Colors.white : Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.darkMode ? Colors.white : Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        cursorColor: widget.darkMode ? Colors.white : Colors.black,
        controller: TextEditingController(text: _itemName),
        keyboardType: TextInputType.text,
        onChanged: (name) => _itemName = name,
        style: const TextStyle(color: Colors.white),
      );
    }
    return TextField(
      decoration: InputDecoration(
        labelText: 'Item Name',
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(15)),
      ),
      cursorColor: widget.darkMode ? Colors.white : Colors.black,
      controller: TextEditingController(text: _itemName),
      keyboardType: TextInputType.text,
      onChanged: (name) => _itemName = name,
    );
  }

  Widget _buildCategory() {
    if (widget.darkMode) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Category:',
            style: TextStyle(color: Colors.white),
          ),
          CategorySelector(category: _category, darkMode: widget.darkMode),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Category:',
          style: TextStyle(color: Colors.black),
        ),
        CategorySelector(category: _category, darkMode: widget.darkMode),
      ],
    );
  }

  Widget _buildExpiryDate() {
    return CalendarTimeline(
      showYears: true,
      initialDate: _expiryDate,
      firstDate: _expiryDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateSelected: (date) {
        setState(() {
          _expiryDate = date!;
        });
      },
      leftMargin: 0,
      monthColor: widget.darkMode ? Colors.white : Colors.black,
      dayColor: Colors.grey[400],
      dayNameColor: Colors.white,
      activeDayColor: Colors.white,
      activeBackgroundDayColor: Color(int.parse(widget.accentColor)),
      dotsColor: const Color(0xFF333A47),
      selectableDayPredicate: (date) => date.day != 23,
      locale: 'en',
    );
  }

  Widget _addButton() {
    return AnimatedButton(
      height: 53,
      width: 200,
      text: widget.item != null ? 'Update Item' : 'Add Item',
      isReverse: true,
      selectedTextColor: Colors.white,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      selectedBackgroundColor: Color(int.parse(widget.accentColor)),
      backgroundColor: Colors.black,
      borderColor: Colors.white,
      borderRadius: 15,
      borderWidth: 2,
      onPress: () => _setItemAndDismiss(context),
    );
  }
}
