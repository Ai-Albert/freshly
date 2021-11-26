import 'package:flutter/material.dart';
import 'package:freshly/models/food_item.dart';

class FoodItemListTile extends StatelessWidget {
  const FoodItemListTile({required Key key, required this.item, required this.onTap}) : super(key: key);

  final FoodItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      margin: const EdgeInsets.all(6.0),
      color: Colors.grey[800],
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        onTap: onTap,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildTile(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    const TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
    );
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Opacity(
            opacity: 0.0,
            child: Icon(Icons.arrow_forward_ios),
          ),
          Text(item.formattedDate, style: style),
          const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }
}
