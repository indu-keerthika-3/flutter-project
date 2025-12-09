import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/flower.dart';
import '../data/dummy_flowers.dart';
import '../providers/cart_provider.dart';

class FlowerListScreen extends StatefulWidget {
  final String? event;
  final String? category;
  final String? searchQuery;

  const FlowerListScreen({
    super.key,
    this.event,
    this.category,
    this.searchQuery,
  });

  @override
  _FlowerListScreenState createState() => _FlowerListScreenState();
}

class _FlowerListScreenState extends State<FlowerListScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name';
  List<Flower> _filteredFlowers = [];

  @override
  void initState() {
    super.initState();

    _searchQuery = widget.searchQuery ?? '';
    _searchController.text = _searchQuery;

    _filteredFlowers = _getFilteredFlowers();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _prepareAnimations();
    _controller.forward();
  }

  void _prepareAnimations() {
    // make sure animations list length matches flowers length
    _animations = List.generate(_filteredFlowers.length, (index) {
      final start = (index * 0.03).clamp(0.0, 0.8);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, 1.0, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Flower> _getFilteredFlowers() {
    List<Flower> flowers = List.from(dummyFlowers);

    if (widget.event != null) {
      flowers = flowers.where((f) => f.event == widget.event).toList();
    }

    if (widget.category == 'local') {
      flowers = flowers.where((f) => f.isLocal).toList();
    } else if (widget.category == 'non_local') {
      flowers = flowers.where((f) => !f.isLocal).toList();
    } else if (widget.category == 'seasonal') {
      flowers = flowers.where((f) => f.isSeasonal).toList();
    } else if (widget.category == 'off_seasonal') {
      flowers = flowers.where((f) => !f.isSeasonal).toList();
    }

    if (_searchQuery.isNotEmpty) {
      flowers = flowers
          .where(
            (f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    flowers.sort(
      (a, b) => _sortBy == 'price'
          ? a.price.compareTo(b.price)
          : a.name.compareTo(b.name),
    );

    return flowers;
  }

  void _updateFilters() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _filteredFlowers = _getFilteredFlowers();
      _controller.reset();
      _prepareAnimations();
      _controller.forward();
    });
  }

  int _columnsForWidth(double width) {
    // tuned for small screens (320) so mobile-first displays 1 column
    if (width >= 1000) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final crossAxisCount = _columnsForWidth(width);
    final isSingleColumn = crossAxisCount == 1;

    // scale values for very narrow screens like 320
    final basePadding = width <= 360 ? 12.0 : 16.0;
    final titleFontSize = isSingleColumn ? 20.0 : 16.0;
    final priceFontSize = isSingleColumn ? 18.0 : 14.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00695C),
        elevation: 0,

        // 🔥 THIS MAKES THE BACK ARROW WHITE
        iconTheme: const IconThemeData(color: Colors.white),

        title: Text(
          'Flowers',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  if (cart.cart.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cart.cart.length}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, '/order'),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD9), Color(0xFF00695C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Search Bar (reduced padding on very small widths)
            Padding(
              padding: EdgeInsets.all(basePadding),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _updateFilters(),
                  onChanged: (value) {
                    // live filtering as user types (optional)
                    _searchQuery = value;
                    _updateFilters();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search flowers...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF00695C),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _updateFilters();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    // ignore: deprecated_member_use
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ),

            // Flowers list/grid
            Expanded(
              child: _filteredFlowers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.local_florist,
                            size: 100,
                            color: Color(0xFFF8BBD9),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No flowers available',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(max(12, basePadding)),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        // For single column on small phones, use a taller cardAspect so everything fits
                        childAspectRatio: isSingleColumn ? 1.45 : 0.75,
                      ),
                      itemCount: _filteredFlowers.length,
                      itemBuilder: (context, index) {
                        final flower = _filteredFlowers[index];
                        final animation = index < _animations.length
                            ? _animations[index]
                            : AlwaysStoppedAnimation(1.0);

                        return FadeTransition(
                          opacity: animation,
                          child: _buildFlowerCard(
                            context,
                            flower,
                            isSingleColumn,
                            // pass sizes for use inside
                            cardMaxHeight: isSingleColumn
                                ? min(220, height * 0.36)
                                : 320,
                            titleFontSize: titleFontSize,
                            priceFontSize: priceFontSize,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowerCard(
    BuildContext context,
    Flower flower,
    bool isSingleColumn, {
    required double cardMaxHeight,
    required double titleFontSize,
    required double priceFontSize,
  }) {
    final placeholderUrl =
        'https://via.placeholder.com/800x600?text=Image+not+found';

    return GestureDetector(
      onTap: () {
        // optional: open details
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints(maxHeight: cardMaxHeight, minHeight: 120),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // background image with error fallback
              Image.network(
                flower.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) =>
                    Image.network(placeholderUrl, fit: BoxFit.cover),
              ),

              // overlay gradient for readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.12),
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (flower.event.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          flower.event.replaceAll('_', ' ').toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00695C),
                          ),
                        ),
                      ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            flower.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₹${flower.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: priceFontSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF00695C),
                            minimumSize: const Size(64, 36),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Provider.of<CartProvider>(
                              context,
                              listen: false,
                            ).addToCart(flower);
                            ScaffoldMessenger.of(
                              context,
                            ).removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${flower.name} added to cart'),
                                duration: const Duration(milliseconds: 900),
                              ),
                            );
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
