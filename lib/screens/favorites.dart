import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshly/custom_widgets/show_exception_alert_dialog.dart';
import 'package:freshly/models/food_item.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';
import 'helpers/food_item_list_tile.dart';
import 'helpers/list_items_builder.dart';

class Favorites extends StatelessWidget {

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
    return Container(
      child: _buildItems(context),
    );
  }

  Widget _buildItems(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<FoodItem>>(
      stream: database.favoritesStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<FoodItem>(
          key: const Key("list"),
          snapshot: snapshot,
          itemBuilder: (context, item) => Dismissible(
            key: Key('date-${item.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteFoodItem(context, item),
            child: FoodItemListTile(
              key: const Key("tile"),
              item: item,
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}