import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshly/custom_widgets/category_selector.dart';
import 'package:freshly/models/food_item.dart';
import 'package:freshly/custom_widgets/show_exception_alert_dialog.dart';
import 'package:freshly/services/database.dart';
import 'package:intl/intl.dart';

class AddItem extends StatefulWidget {

  // The FoodItem is passed into show() if editing an existing item, otherwise item is null
  const AddItem({Key? key, required this.database, this.item}) : super(key: key);

  final Database database;
  final FoodItem? item;

  /* We use this function to go to this page because we need to do MaterialPageRoute
   * for onPressed since onPressed requires a function and AddJobPage is a Widget
   */
  static Future<void> show(BuildContext context, {required Database database, FoodItem? item}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => AddItem(database: database, item: item),
        fullscreenDialog: true,
      ),
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
      if (item.name == '' || item.name == null) {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          title: const Text('Add an Item'),
          actions: <Widget>[
            TextButton(
              child: Text(
                widget.item != null ? 'Update' : 'Add',
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              onPressed: () => _setItemAndDismiss(context),
            )
          ],
        ),

        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30.0),
                _buildName(),
                const SizedBox(height: 30.0),
                _buildCategory(),
                const SizedBox(height: 30.0),
                _buildExpiryDate(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Item Name',
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(15)),
      ),
      cursorColor: Colors.black,
      controller: TextEditingController(text: _itemName),
      keyboardType: TextInputType.text,
      onChanged: (name) => _itemName = name,
    );
  }

  Widget _buildExpiryDate() {
    return CalendarTimeline(
      showYears: true,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateSelected: (date) {
        setState(() {
          _expiryDate = date!;
        });
      },
      leftMargin: 20,
      monthColor: Colors.black,
      dayColor: Colors.teal[200],
      dayNameColor: const Color(0xFF333A47),
      activeDayColor: Colors.white,
      activeBackgroundDayColor: Colors.red,
      dotsColor: const Color(0xFF333A47),
      selectableDayPredicate: (date) => date.day != 23,
      locale: 'en',
    );
  }

  Widget _buildCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Category: ',
          style: TextStyle(color: Colors.black),
        ),
        CategorySelector(category: _category),
      ],
    );
  }
}
