import 'food.dart';

class CartItem {
  final String id;
  final Food food;
  int quantity;
  final String? specialNote;

  CartItem({
    required this.id,
    required this.food,
    this.quantity = 1,
    this.specialNote,
  });

  // Calculate total price for this cart item
  double get totalPrice => food.price * quantity;
}