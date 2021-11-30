import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshly/models/food_item.dart';
import 'package:freshly/models/theme_settings.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<FoodItem>> foodItemsStream();
  Stream<List<FoodItem>> favoritesStream();
  Future<void> setFoodItem(FoodItem item);
  Future<void> deleteFoodItem(String id);

  Future<ThemeSettings> getTheme();
  Future<void> setTheme(bool darkMode, String accentColor);

  Future<void> deleteData();
}

// For creating unique ids for new entries
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  // Getting list of all food items
  @override
  Stream<List<FoodItem>> foodItemsStream() => _service.collectionStream(
    path: APIPath.foodItems(uid),
    builder: (data, documentId) => FoodItem.fromMap(data, documentId),
    sort: (a, b) => a.expiryDate.compareTo(b.expiryDate),
  );

  // Getting list of favorite food items
  @override
  Stream<List<FoodItem>> favoritesStream() => _service.collectionStream(
    path: APIPath.foodItems(uid),
    builder: (data, documentId) => FoodItem.fromMap(data, documentId),
    filterSource: "favorite",
    filterMatch: true,
    sort: (a, b) => a.expiryDate.compareTo(b.expiryDate),
  );

  // Setting date before task to make sure the date itself has a document
  @override
  Future<void> setFoodItem(FoodItem item) async {
    _service.setData(
      path: APIPath.foodItem(uid, item.id),
      data: item.toMap(),
    );
  }

  @override
  Future<void> deleteFoodItem(String id) async {
    await _service.deleteData(path: APIPath.foodItem(uid, id));
  }

  @override
  Future<ThemeSettings> getTheme() async {
    var document = FirebaseFirestore.instance.doc(APIPath.theme(uid));
    var snapshot = await document.get();
    return ThemeSettings.fromMap(snapshot.data());
  }

  @override
  Future<void> setTheme(bool darkMode, String accentColor) async {
    ThemeSettings theme = ThemeSettings(darkMode: darkMode, accentColor: accentColor);
    _service.setData(path: APIPath.theme(uid), data: theme.toMap());
  }

  // Deleting all of a user's data prior to account deletion
  @override
  Future<void> deleteData() async {
    // Deleting items
    var items = FirebaseFirestore.instance.collection(APIPath.foodItems(uid));
    var snapshotsItems = await items.get();
    for (var item in snapshotsItems.docs) {
      await deleteFoodItem(item.id);
      await item.reference.delete();
    }

    // Deleting theme
    items = FirebaseFirestore.instance.collection('users/$uid/theme');
    snapshotsItems = await items.get();
    for (var item in snapshotsItems.docs) {
      await deleteFoodItem(item.id);
      await item.reference.delete();
    }
  }
}
