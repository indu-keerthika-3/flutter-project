import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/flower.dart';
import '../providers/cart_provider.dart';

class FlowerCard extends StatefulWidget {
  final Flower flower;
  const FlowerCard({super.key, required this.flower});

  @override
  State<FlowerCard> createState() => _FlowerCardState();
}

class _FlowerCardState extends State<FlowerCard>
    with SingleTickerProviderStateMixin {
  int _qty = 1;
  bool _fav = false;
  late AnimationController _animController;

  static const Color kPink = Color(0xFFF8BBD9);
  static const Color kTeal = Color(0xFF00695C);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addToCart(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    // Add flower _qty times (compatible with old-style cart which stores Flower instances)
    for (var i = 0; i < _qty; i++) {
      cart.addToCart(widget.flower);
    }

    // show snackbar with Undo
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.flower.name} x$_qty added to cart'),
        backgroundColor: kTeal,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            // remove last _qty occurrences of this flower
            for (var i = 0; i < _qty; i++) {
              cart.removeFromCart(widget.flower);
            }
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flower = widget.flower;
    final priceText = '₹${flower.price.toStringAsFixed(2)}';
    final isLocal = flower.isLocal;

    return FadeTransition(
      opacity: CurvedAnimation(parent: _animController, curve: Curves.easeOut),
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.hardEdge,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;

            // Image widget (reused)
            final image = CachedNetworkImage(
              imageUrl: flower.imageUrl,
              fit: BoxFit.cover,
              width: isNarrow ? double.infinity : 120,
              height: isNarrow ? 180 : 120,
              placeholder: (c, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (c, url, err) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 36, color: Colors.grey),
                ),
              ),
            );

            return InkWell(
              onTap: () {
                // optional: open product details
              },
              child: isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            image,
                            // overlay gradient
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.36),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            // badges & fav
                            Positioned(
                              left: 12,
                              top: 12,
                              child: _buildBadge(isLocal),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: IconButton(
                                icon: Icon(
                                  _fav ? Icons.favorite : Icons.favorite_border,
                                  color: _fav ? Colors.redAccent : Colors.white,
                                ),
                                onPressed: () => setState(() => _fav = !_fav),
                                tooltip: _fav
                                    ? 'Remove favorite'
                                    : 'Add to favorites',
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildContent(priceText, context),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        // left image
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            children: [
                              Positioned.fill(child: image),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.22),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 12,
                                top: 12,
                                child: _buildBadge(isLocal),
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: IconButton(
                                  icon: Icon(
                                    _fav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _fav
                                        ? Colors.redAccent
                                        : Colors.white,
                                  ),
                                  onPressed: () => setState(() => _fav = !_fav),
                                  tooltip: _fav
                                      ? 'Remove favorite'
                                      : 'Add to favorites',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // right content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 10,
                            ),
                            child: _buildContent(priceText, context),
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadge(bool isLocal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isLocal ? 'LOCAL' : 'EXOTIC',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: kTeal,
        ),
      ),
    );
  }

  Widget _buildContent(String priceText, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.flower.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              priceText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: kTeal,
              ),
            ),
            const SizedBox(width: 12),
            if (widget.flower.event.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kPink.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.flower.event.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // quantity selector
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_qty > 1) _qty--;
                      });
                    },
                    tooltip: 'Decrease quantity',
                  ),
                  Text(
                    '$_qty',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _qty++),
                    tooltip: 'Increase quantity',
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _addToCart(context),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
