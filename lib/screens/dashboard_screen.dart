import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flower_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> _promo = [
    {
      'title': 'Wedding Collections',
      'subtitle': 'Bouquets & garlands for ceremonies',
      'image': 'assets/promo_wedding.jpg',
      'key': 'marriage',
    },
    {
      'title': 'Festival Specials',
      'subtitle': 'Marigold strings & temple-ready garlands',
      'image': 'assets/promo_festival.jpg',
      'key': 'special_events',
    },
    {
      'title': 'Daily Essentials',
      'subtitle': 'Tulasi & lotus for pooja',
      'image': 'assets/promo_daily.jpg',
      'key': 'local',
    },
  ];

  final List<Map<String, dynamic>> _events = [
    {'name': 'Marriage', 'icon': Icons.favorite, 'key': 'marriage'},
    {'name': 'House Warming', 'icon': Icons.home, 'key': 'house_warming'},
    {'name': 'Death', 'icon': Icons.grade, 'key': 'death'},
    {'name': 'Valentine', 'icon': Icons.favorite_border, 'key': 'valentine'},
    {
      'name': 'Special Events',
      'icon': Icons.celebration,
      'key': 'special_events',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Local',
      'icon': 'location_on',
      'key': 'local',
      'desc': 'Godavari & Krishna',
      'image': 'assets/cat_local.jpg',
    },
    {
      'name': 'Non-Local',
      'icon': 'public',
      'key': 'non_local',
      'desc': 'Imported picks',
      'image': 'assets/cat_nonlocal.jpg',
    },
    {
      'name': 'Seasonal',
      'icon': 'wb_sunny',
      'key': 'seasonal',
      'desc': 'Best of the season',
      'image': 'assets/cat_seasonal.jpg',
    },
    {
      'name': 'Off-Seasonal',
      'icon': 'ac_unit',
      'key': 'off_seasonal',
      'desc': 'Year-round',
      'image': 'assets/cat_offseason.jpg',
    },
  ];

  int _promoIndex = 0;
  final PageController _promoController = PageController(
    viewportFraction: 0.95,
  );
  Timer? _autoTimer;
  bool _paused = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_paused || !_promoController.hasClients) return;

      final next = (_promoIndex + 1) % _promo.length;

      _promoController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );

      setState(() => _promoIndex = next);
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    _autoTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateTo({String? event, String? category, String? search}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlowerListScreen(
          event: event,
          category: category,
          searchQuery: search,
        ),
      ),
    );
  }

  IconData _iconFromString(String name) {
    switch (name) {
      case 'location_on':
        return Icons.location_on;
      case 'public':
        return Icons.public;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'ac_unit':
        return Icons.ac_unit;
      default:
        return Icons.local_florist;
    }
  }

  @override
  Widget build(BuildContext context) {
    const kPink = Color(0xFFF8BBD9);
    const kTeal = Color(0xFF00695C);

    // -------------------- PROMO CARD (UPGRADED) --------------------
    Widget promoCard(Map<String, dynamic> p) {
      const kTeal = Color(0xFF00695C);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: GestureDetector(
          onTap: () => _navigateTo(event: p['key']),
          child: MouseRegion(
            onEnter: (_) => setState(() => p['hover'] = true),
            onExit: (_) => setState(() => p['hover'] = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image (slightly scales on hover)
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 400),
                      tween: Tween(
                        begin: 1.0,
                        end: (p['hover'] == true) ? 1.08 : 1.0,
                      ),
                      builder: (context, scale, child) =>
                          Transform.scale(scale: scale, child: child),
                      child: Image.asset(
                        p['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),

                    // Soft gradient overlay for readability
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.20),
                              Colors.black.withOpacity(0.40),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content (left aligned)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // small label
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              p.containsKey('tag') ? p['tag'] : 'FEATURED',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: kTeal,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Title
                          Text(
                            p['title'],
                            style: GoogleFonts.lato(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Subtitle
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Text(
                              p['subtitle'],
                              style: GoogleFonts.lato(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const Spacer(),

                          // CTA Row (button + small hint)
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _navigateTo(event: p['key']),
                                icon: const Icon(Icons.search, color: kTeal),
                                label: const Text('Explore'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: kTeal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  elevation: (p['hover'] == true) ? 8 : 4,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (p.containsKey('hint'))
                                Text(
                                  p['hint'],
                                  style: GoogleFonts.lato(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // bottom-left pager dot mimic (pure decoration)
                    Positioned(
                      bottom: 10,
                      left: 18,
                      child: Row(
                        children: List.generate(3, (i) {
                          final active = i == (p['index'] ?? 0);
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6),
                            width: active ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? kTeal
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // -------------------- EVENT PILL --------------------
    Widget eventPill(Map<String, dynamic> e) {
      return GestureDetector(
        onTap: () => _navigateTo(event: e['key']),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(right: 12),
          width: 200,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kPink, kTeal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(e['icon'], color: kTeal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  e['name'],
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // -------------------- CATEGORY CARD --------------------
    Widget categoryTile(Map<String, dynamic> c) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => _navigateTo(category: c['key']),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    c['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey[200]),
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.28)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Icon(_iconFromString(c['icon']), color: kTeal),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          c['name'],
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kTeal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c['desc'],
                        style: GoogleFonts.lato(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Explore',
                            style: GoogleFonts.lato(
                              color: kTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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

    // -------------------- SPECIAL CARD --------------------
    Widget specialCard(Map<String, dynamic> s) {
      return GestureDetector(
        onTap: () => _navigateTo(event: s['key']),
        child: Container(
          width: 260,
          margin: const EdgeInsets.only(right: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  s['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[300]),
                ),
                Container(color: Colors.black.withOpacity(0.25)),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'FEATURED',
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: kTeal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s['title'],
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s['subtitle'],
                        style: GoogleFonts.lato(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
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

    // -------------------- MAIN UI --------------------
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'PrettyPetals',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: kTeal),
        ),
        backgroundColor: kPink,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kPink.withOpacity(0.06), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Listener(
          onPointerDown: (_) => setState(() => _paused = true),
          onPointerUp: (_) => setState(() => _paused = false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------- PROMO SLIDER --------
                SizedBox(
                  height: 220,
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _paused = true),
                    onExit: (_) => setState(() => _paused = false),
                    child: PageView.builder(
                      controller: _promoController,
                      itemCount: _promo.length,
                      onPageChanged: (i) => setState(() => _promoIndex = i),
                      itemBuilder: (_, i) => promoCard(_promo[i]),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // -------- PAGE INDICATORS --------
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _promo.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _promoIndex == i ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _promoIndex == i ? kTeal : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // -------- SEARCH BAR --------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: kTeal),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (q) {
                                    if (q.trim().isNotEmpty) {
                                      _navigateTo(search: q.trim());
                                    }
                                  },
                                  decoration: const InputDecoration.collapsed(
                                    hintText: 'Search flowers...',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final q = _searchController.text.trim();
                          if (q.isNotEmpty) _navigateTo(search: q);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // -------- EVENTS --------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Popular Events',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: kTeal,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _events.length,
                    itemBuilder: (_, i) => eventPill(_events[i]),
                  ),
                ),

                const SizedBox(height: 18),

                // -------- SPECIAL COLLECTIONS --------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Special Collections',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: kTeal,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _promo.length,
                    itemBuilder: (_, i) => specialCard(_promo[i]),
                  ),
                ),

                const SizedBox(height: 18),

                // -------- CATEGORIES --------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Categories',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: kTeal,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (_, i) => Container(
                      margin: EdgeInsets.all(12),
                      width: 280,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: categoryTile(_categories[i]),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
