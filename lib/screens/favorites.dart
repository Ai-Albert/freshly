import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshly/custom_widgets/show_exception_alert_dialog.dart';
import 'package:freshly/models/food_item.dart';
import 'package:freshly/models/theme_settings.dart';
import 'package:freshly/screens/add_item.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';
import 'helpers/food_item_list_tile.dart';
import 'helpers/list_items_builder.dart';

class Favorites extends StatelessWidget {

  const Favorites({Key? key, required this.scrollController}) : super(key: key);

  final ScrollController scrollController;

  Future<void> _deleteFoodItem(BuildContext context, FoodItem item) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteFoodItem(item.id);
    } on FirebaseException catch(e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
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
            bool _darkMode = snapshot.data != null ? snapshot.data!.darkMode : false;
            String _accentColor = snapshot.data != null ? snapshot.data!.accentColor : '0xFFE53935';
            return Container(
              color: _darkMode ? Colors.black : Colors.white,
              child: _buildItems(context, _darkMode, _accentColor),
            );
          case ConnectionState.none:
            return Container(color: Colors.transparent);
        }
      },
    );
  }

  Widget _buildItems(BuildContext context, bool darkMode, String accentColor) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<FoodItem>>(
      stream: database.favoritesStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<FoodItem>(
          scrollController: scrollController,
          context: context,
          snapshot: snapshot,
          itemBuilder: (context, item) => Dismissible(
            key: Key('date-${item.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteFoodItem(context, item),
            child: FoodItemListTile(
              darkMode: darkMode,
              accentColor: accentColor,
              item: item,
              onTap: () => AddItem.show(context, database: database, item: item, darkMode: darkMode, accentColor: accentColor),
            ),
          ),
        );
      },
    );
  }
}