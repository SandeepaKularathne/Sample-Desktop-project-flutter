import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime timestamp;
  final String status;

  const Order({
    required this.id,
    required this.items,
    required this.timestamp,
    required this.status,
  });

  // Calculate total order amount
  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}