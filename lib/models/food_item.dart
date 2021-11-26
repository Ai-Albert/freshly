import 'package:intl/intl.dart';

class FoodItem {
  FoodItem({required this.id, required this.name, required this.expiryDate, required this.category, required this.favorite});

  final String id;
  final String name;
  final DateTime expiryDate;
  final String category;
  final bool favorite;

  String get formattedDate => DateFormat('MM-dd-yyyy').format(expiryDate);

  factory FoodItem.fromMap(Map<String, dynamic> data, String id) {
    return FoodItem(
      id: id,
      name: data['name'],
      expiryDate: DateTime.fromMillisecondsSinceEpoch(data['expiryDate']),
      category: data['category'],
      favorite: data['favorite'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'expiryDate': expiryDate.millisecondsSinceEpoch,
      'category': category,
      'favorite': favorite,
    };
  }
}