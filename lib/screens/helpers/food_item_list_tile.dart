import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:freshly/models/food_item.dart';
import 'package:freshly/services/database.dart';
import 'package:provider/provider.dart';

class FoodItemListTile extends StatefulWidget {
  const FoodItemListTile({
    Key? key,
    required this.item,
    required this.onTap,
    required this.darkMode,
    required this.accentColor,
  }) : super(key: key);

  final FoodItem item;
  final VoidCallback onTap;
  final bool darkMode;
  final String accentColor;

  @override
  State<FoodItemListTile> createState() => _FoodItemListTileState();
}

class _FoodItemListTileState extends State<FoodItemListTile> {

  late final bool darkMode = widget.darkMode;
  late final String accentColor = widget.accentColor;

  late List<AnimatedIconItem> notFavorited = [
    AnimatedIconItem(
      icon: Icon(Icons.favorite_border, color: darkMode ? Colors.white : Colors.black),
    ),
    AnimatedIconItem(
      icon: Icon(Icons.favorite, color: Color(int.parse(accentColor))),
    ),
  ];
  late List<AnimatedIconItem> favorited = [
    AnimatedIconItem(
      icon: Icon(Icons.favorite, color: Color(int.parse(accentColor))),
    ),
    AnimatedIconItem(
      icon: Icon(Icons.favorite_border, color: darkMode ? Colors.white : Colors.black),
    ),
  ];
  late List<AnimatedIconItem> currAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.item.favorite) {
      currAnimation = favorited;
    }
    else {
      currAnimation = notFavorited;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime threshold = DateTime.now().subtract(const Duration(days: 1));
    bool expired = threshold.compareTo(widget.item.expiryDate) > 0;

    return Card(
      color: expired ? Colors.red : (darkMode ? Colors.grey[900] : Colors.white),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      margin: const EdgeInsets.all(6.0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        onTap: widget.onTap,
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
    TextStyle style = TextStyle(
      color: darkMode ? Colors.white : Colors.black,
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
                  Text(widget.item.name, style: style),
                  const SizedBox(height: 5),
                  Text(widget.item.category, style: style),
                  const SizedBox(height: 5),
                  Text(widget.item.formattedDate, style: style),
                ],
              ),
              AnimatedIconButton(
                icons: currAnimation,
                onPressed: () {
                  Database database = Provider.of<Database>(context, listen: false);
                  setState(() {
                    widget.item.favorite = !widget.item.favorite;
                    database.setFoodItem(widget.item);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
