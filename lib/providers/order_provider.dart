import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'dart:math';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  /// Place an order using the contents of the [cart].
  /// Returns the created Order.
  Order placeOrderFromCart(CartProvider cart) {
    if (cart.items.isEmpty) {
      throw StateError('Cart is empty');
    }

    // create a copy of cart items
    final List<CartItem> itemsCopy = cart.items
        .map((ci) => CartItem(flower: ci.flower, quantity: ci.quantity))
        .toList();

    // generate a simple random order id; replace with your real id generator if needed
    final String orderId =
        'ORD-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9000) + 1000}';
    final order = Order(
      orderId: orderId,
      orderDate: DateTime.now(),
      items: itemsCopy,
    );

    _orders.insert(0, order); // newest first
    notifyListeners();

    // clear the cart after placing order
    cart.clearCart();

    return order;
  }

  /// Optionally you can add a direct placeOrder method if you want to pass CartItems directly:
  Order placeOrderDirect(List<CartItem> items) {
    if (items.isEmpty) throw StateError('No items provided');
    final String orderId =
        'ORD-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9000) + 1000}';
    final order = Order(
      orderId: orderId,
      orderDate: DateTime.now(),
      items: items
          .map((i) => CartItem(flower: i.flower, quantity: i.quantity))
          .toList(),
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}
