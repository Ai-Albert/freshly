class APIPath {
  static String foodItems(String uid) => 'users/$uid/foodItems';
  static String foodItem(String uid, String itemId) => 'users/$uid/foodItems/$itemId';
}