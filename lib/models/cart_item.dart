import 'flower.dart';

class CartItem {
  Flower flower;
  int quantity;

  CartItem({required this.flower, this.quantity = 1});

  double get itemTotal => flower.price * quantity;
}
