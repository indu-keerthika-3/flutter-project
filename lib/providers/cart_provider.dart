import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/flower.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Modern API: list of CartItem (flower + quantity)
  List<CartItem> get items => List.unmodifiable(_items);

  /// Backwards compatibility: flattened list of Flower objects (each repeated by its quantity)
  List<Flower> get cart {
    final List<Flower> flat = [];
    for (final it in _items) {
      for (var i = 0; i < it.quantity; i++) {
        flat.add(it.flower);
      }
    }
    return List.unmodifiable(flat);
  }

  /// Total price (sum of itemTotal)
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.itemTotal);

  /// Backwards compatibility alias
  double get total => totalPrice;

  /// Total number of units (sum of quantities)
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Check if a flower exists in cart (by id)
  bool containsFlower(String flowerId) =>
      _items.any((it) => it.flower.id == flowerId);

  /// Find an item by flower id (returns null if not found)
  CartItem? findByFlowerId(String flowerId) {
    final idx = _items.indexWhere((it) => it.flower.id == flowerId);
    return idx >= 0 ? _items[idx] : null;
  }

  /// Add flower to cart. If already present, increases quantity.
  /// You can pass an optional [qty] to add multiple units at once.
  void addToCart(Flower flower, {int qty = 1}) {
    if (qty <= 0) return;
    final idx = _items.indexWhere((it) => it.flower.id == flower.id);
    if (idx >= 0) {
      _items[idx].quantity += qty;
    } else {
      _items.add(CartItem(flower: flower, quantity: qty));
    }
    notifyListeners();
  }

  /// Remove one unit of the given flower. If quantity becomes 0, the CartItem is removed.
  void removeFromCart(Flower flower) {
    final idx = _items.indexWhere((it) => it.flower.id == flower.id);
    if (idx == -1) return;
    final item = _items[idx];
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeAt(idx);
    }
    notifyListeners();
  }

  /// Remove the whole CartItem for the flower regardless of quantity.
  void removeItemCompletely(Flower flower) {
    _items.removeWhere((it) => it.flower.id == flower.id);
    notifyListeners();
  }

  /// Increase quantity for a CartItem (by reference).
  void increaseQty(CartItem item, {int by = 1}) {
    if (by <= 0) return;
    final idx = _items.indexOf(item);
    if (idx == -1) return;
    _items[idx].quantity += by;
    notifyListeners();
  }

  /// Decrease quantity for a CartItem (by reference). If quantity reaches 0 it's removed.
  void decreaseQty(CartItem item, {int by = 1}) {
    if (by <= 0) return;
    final idx = _items.indexOf(item);
    if (idx == -1) return;
    final it = _items[idx];
    if (it.quantity > by) {
      it.quantity -= by;
    } else {
      _items.removeAt(idx);
    }
    notifyListeners();
  }

  /// Set quantity explicitly. If qty <= 0, item is removed.
  void setQuantity(Flower flower, int qty) {
    final idx = _items.indexWhere((it) => it.flower.id == flower.id);
    if (qty <= 0) {
      if (idx >= 0) {
        _items.removeAt(idx);
        notifyListeners();
      }
      return;
    }
    if (idx >= 0) {
      _items[idx].quantity = qty;
    } else {
      _items.add(CartItem(flower: flower, quantity: qty));
    }
    notifyListeners();
  }

  /// Clear the entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
