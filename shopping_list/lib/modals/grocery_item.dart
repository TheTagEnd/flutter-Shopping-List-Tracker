import 'package:shopping_list/modals/category.dart';

class GroceryItem {
  GroceryItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});
  final String id;
  final String name;
  int quantity;
  final Category category;
}
