import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:freshly/models/food_item.dart';

class FoodItemListTile extends StatelessWidget {
  const FoodItemListTile({Key? key, required this.item, required this.onTap}) : super(key: key);

  final FoodItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      margin: const EdgeInsets.all(6.0),
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
      color: Colors.black,
      fontSize: 16.0,
    );
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: style),
                  const SizedBox(height: 5),
                  Text(item.category, style: style),
                  const SizedBox(height: 5),
                  Text(item.formattedDate, style: style),
                ],
              ),
              AnimatedIconButton(
                icons: const [
                  AnimatedIconItem(
                    icon: Icon(Icons.favorite_border, color: Colors.black,),
                  ),
                  AnimatedIconItem(
                    icon: Icon(Icons.favorite, color: Colors.red),
                  ),
                ],
                onPressed: () => print("outer"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
