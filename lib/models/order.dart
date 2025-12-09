import 'cart_item.dart';

class Order {
  final String orderId;
  final DateTime orderDate;
  final List<CartItem> items;

  Order({required this.orderId, required this.orderDate, required this.items});

  double get totalPrice => items.fold(0, (sum, item) => sum + item.itemTotal);
}
