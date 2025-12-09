import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const kTeal = Color(0xFF00695C);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          // Flower Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.flower.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.local_florist),
            ),
          ),

          const SizedBox(width: 12),

          // Name + Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.flower.name,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kTeal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹${item.itemTotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Buttons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: kTeal),
                onPressed: () {
                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).decreaseQty(item);
                },
              ),
              Text(
                "${item.quantity}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: kTeal),
                onPressed: () {
                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).increaseQty(item);
                },
              ),
            ],
          ),

          // Delete (remove entire item)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              Provider.of<CartProvider>(
                context,
                listen: false,
              ).removeItemCompletely(item.flower);
            },
          ),
        ],
      ),
    );
  }
}
