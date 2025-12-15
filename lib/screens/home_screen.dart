import 'package:flutter/material.dart';

import '../widgets/app_gradient_bg.dart';
import '../cart/cart_screen.dart';
import '../product/product_details_screen.dart';
import '../profile/profile_screen.dart';
import '../services/user_service.dart';
import '../services/user_management_service.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _userService = UserService();
  final _userManagementService = UserManagementService();
  String? _selectedCategory; // null means show all
  
  // Animation controller for navbar
  late AnimationController _navAnimationController;

  @override
  void initState() {
    super.initState();
    _checkBannedStatus();
    _navAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }
  
  @override
  void dispose() {
    _navAnimationController.dispose();
    super.dispose();
  }

  void _checkBannedStatus() async {
    // Check if current user is banned
    if (_userService.isLoggedIn) {
      final email = _userService.getEmail();
      if (_userManagementService.isUserBanned(email)) {
        // User is banned, log them out
        await _userService.logout();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'You are banned. Please contact admin for account recovery.'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 4),
            ),
          );
        });
      }
    }
  }

  // -------------------------------
  // DYNAMIC FEATURED WATCHES
  // -------------------------------
  final List<Map<String, dynamic>> featuredWatches = [
    {
      "image": "assets/images/e32d27bcae-631fc6ddb02fe5b97199.png",
      "brand": "Rolex",
      "name": "Rolex Daytona",
      "sub": "Cosmograph",
      "price": 28500.0,
      "qty": 2,
      "rating": 4.9,
      "reference": "116500LN",
      "case": "40mm",
      "material": "Oystersteel",
      "movement": "Cal. 4130",
      "category": "Chrono",
    },
    {
      "image": "assets/images/a20300d8e0-e7b4be10de44aaaceb2c.png",
      "brand": "Omega",
      "name": "Omega Seamaster",
      "sub": "Diver 300M",
      "price": 5400.0,
      "qty": 6,
      "rating": 4.7,
      "reference": "210.30.42.20.03.001",
      "case": "42mm",
      "material": "Stainless Steel",
      "movement": "Cal. 8800",
      "category": "Diver",
    },
    {
      "image": "assets/images/7d898cc810-deaa45e61c98e228be9b.png",
      "brand": "TAG Heuer",
      "name": "TAG Heuer Carrera",
      "sub": "Chronograph",
      "price": 6200.0,
      "qty": 0,
      "rating": 4.5,
      "reference": "CBN2A1A.BA0643",
      "case": "44mm",
      "material": "Steel & Ceramic",
      "movement": "Cal. Heuer 02",
      "category": "Chrono",
    },
    {
      "image": "assets/images/2bb5acb5cc-f95da6ec11dc10051b5a.png",
      "brand": "Lundates",
      "name": "Heritage Chrono",
      "sub": "Vintage Chronograph",
      "price": 3200.0,
      "qty": 8,
      "rating": 4.6,
      "reference": "LC-01",
      "case": "41mm",
      "material": "Stainless Steel",
      "movement": "Auto Cal. 510",
      "category": "Chrono",
    },
    {
      "image": "assets/images/da7c4fc3dc-9d9f00dd116f6b4c6d82.png",
      "brand": "Aurum",
      "name": "Aurum Voyager",
      "sub": "Gold Diver",
      "price": 7800.0,
      "qty": 5,
      "rating": 4.4,
      "reference": "AV-728",
      "case": "40mm",
      "material": "Yellow Gold",
      "movement": "Cal. 8900",
      "category": "Diver",
    },
    {
      "image": "assets/images/436c8f3702-07e59a71bcec5bc366e2.png",
      "brand": "Omnivox",
      "name": "Omnivox Eclipse",
      "sub": "Midnight Steel",
      "price": 4100.0,
      "qty": 7,
      "rating": 4.3,
      "reference": "OE-11",
      "case": "39mm",
      "material": "Brushed Steel",
      "movement": "Cal. 6R35",
      "category": "Dress",
    },
  ];

  // -------------------------------
  // DYNAMIC CATEGORIES
  // -------------------------------
  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.account_circle, "label": "Dress"},
    {"icon": Icons.list, "label": "Diver"},
    {"icon": Icons.flight, "label": "Pilot"},
    {"icon": Icons.timer, "label": "Chrono"},
  ];

  // -------------------------------
  // DYNAMIC DEALS
  // -------------------------------
  final List<Map<String, dynamic>> deals = [
    {
      "image": "assets/images/edb34eeca5-bb983db7cba8a7e4f85a.png",
      "brand": "Patek Philippe",
      "name": "Calatrava 5227R",
      "model": "Calatrava 5227R",
      "price": 35150.0,
      "oldPrice": 39050,
      "qty": 4,
      "rating": 4.8,
      "reference": "5227R-001",
      "case": "39mm",
      "material": "Rose Gold",
      "movement": "Cal. 324 S C",
      "category": "Dress",
    },
    {
      "image": "assets/images/6dcf8bfb3d-e0905e8a6cb9ca947c1b.png",
      "brand": "Noir Atelier",
      "name": "Noir Mono",
      "model": "Stealth Edition",
      "price": 1950.0,
      "oldPrice": 2300,
      "qty": 10,
      "rating": 4.2,
      "reference": "NM-01",
      "case": "40mm",
      "material": "Cerakote Steel",
      "movement": "Quartz 5Y",
      "category": "Pilot",
    },
    {
      "image": "assets/images/7a334b1958-de36d6249b8c486796f8.png",
      "brand": "Adorex",
      "name": "Adorex Regent",
      "model": "Classic Dress",
      "price": 3600.0,
      "oldPrice": 4200,
      "qty": 4,
      "rating": 4.5,
      "reference": "AR-1963",
      "case": "38mm",
      "material": "Rose Gold",
      "movement": "Cal. L893",
      "category": "Dress",
    },
    {
      "image": "assets/images/88bc0ae1cb-f14798ba288c061fbaf3.png",
      "brand": "Laurex",
      "name": "Laurex Abyss",
      "model": "Deep Blue Diver",
      "price": 5200.0,
      "oldPrice": 6100,
      "qty": 9,
      "rating": 4.7,
      "reference": "LA-300",
      "case": "42mm",
      "material": "Steel & Gold",
      "movement": "Cal. 888",
      "category": "Diver",
    },
  ];

  // -------------------------------
  // FILTERED LISTS
  // -------------------------------
  // Featured watches always show all (no filtering)
  List<Map<String, dynamic>> get filteredFeaturedWatches {
    return featuredWatches;
  }

  // Deals are filtered by selected category
  List<Map<String, dynamic>> get filteredDeals {
    if (_selectedCategory == null) return deals;
    return deals
        .where((deal) => deal["category"] == _selectedCategory)
        .toList();
  }

  final List<Map<String, String>> _notifications = [
    {"title": "Price Drop Alert", "subtitle": "Omega Seamaster now \$5,200."},
    {"title": "Wishlist Update", "subtitle": "Rolex Daytona back in stock."},
    {"title": "New Arrival", "subtitle": "Patek Philippe Nautilus added."},
  ];

  bool get hasUnreadNotifications => _notifications.isNotEmpty;

  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = const [
    {"icon": Icons.home, "label": "Home"},
    {"icon": Icons.search, "label": "Discover"},
    {"icon": Icons.favorite_border, "label": "Wishlist"},
    {"icon": Icons.shopping_cart_outlined, "label": "Cart"},
  ];

  void _showNotificationModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xff111111),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white54),
                  )
                ],
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: _notifications.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            "All caught up!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _notifications.length,
                        separatorBuilder: (_, __) => Divider(
                          color: Colors.white12,
                          height: 1,
                        ),
                        itemBuilder: (_, index) {
                          final notification = _notifications[index];
                          return Dismissible(
                            key: ValueKey("${notification["title"]}_$index"),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              setState(() {
                                _notifications.removeAt(index);
                              });
                            },
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              title: Text(
                                notification["title"] ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                notification["subtitle"] ?? "",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      // -----------------------------------------------------------
      // MODERN ANIMATED BOTTOM NAVIGATION BAR
      // -----------------------------------------------------------
      bottomNavigationBar: _ModernNavBar(
        items: _navItems,
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          if (_navItems[index]["label"] == "Cart") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CartScreen(),
              ),
            );
            return;
          }
          if (_selectedIndex == index) return;
          setState(() => _selectedIndex = index);
        },
      ),

      // -----------------------------------------------------------
      // MAIN CONTENT
      // -----------------------------------------------------------
      body: AppGradientBackground(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const _PlaceholderTab(
          icon: Icons.search,
          title: "Discover watches coming soon",
        );
      case 2:
        return const _PlaceholderTab(
          icon: Icons.favorite_border,
          title: "Wishlist is currently empty",
        );
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------
            // HEADER
            // -----------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome Back,",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 14)),
                      Text(
                          _userService.isLoggedIn
                              ? _userService.getDisplayName()
                              : "Guest",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ]),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showNotificationModal(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xff1A1A1A),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_none,
                                color: Colors.white),
                            if (hasUnreadNotifications)
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF44336),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xff1A1A1A),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: _buildProfileAvatar(),
                    )
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------------------
            // SEARCH BAR
            // -----------------------------------------------------------
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: const Color(0xff1A1A1A),
                  borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white54),
                  SizedBox(width: 12),
                  Text("Search for a watch...",
                      style: TextStyle(color: Colors.white54))
                ],
              ),
            ),

            const SizedBox(height: 25),

            // -----------------------------------------------------------
            // FEATURED HEADER
            // -----------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Featured Timepieces",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text("See All", style: TextStyle(color: Colors.amber)),
              ],
            ),

            const SizedBox(height: 15),

            // -----------------------------------------------------------
            // DYNAMIC FEATURED LIST (HORIZONTAL)
            // -----------------------------------------------------------
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredWatches.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, index) {
                  final item = featuredWatches[index];
                  return _FeaturedCard(
                    product: item,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(product: item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // -----------------------------------------------------------
            // CATEGORIES
            // -----------------------------------------------------------
            const Text("Categories",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat["label"];
                return _CategoryItem(
                  icon: cat["icon"],
                  label: cat["label"],
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      // Toggle: if same category is clicked, deselect it
                      _selectedCategory =
                          isSelected ? null : cat["label"] as String;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // -----------------------------------------------------------
            // DEALS SECTION
            // -----------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Exclusive Deals",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text("See All", style: TextStyle(color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 15),

            // -----------------------------------------------------------
            // DYNAMIC DEALS LIST
            // -----------------------------------------------------------
            filteredDeals.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "No deals found in this category",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                : Column(
                    children: filteredDeals.map((deal) {
                      return _DealCard(
                        product: deal,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: deal),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // BUILD PROFILE AVATAR
  // -------------------------------
  Widget _buildProfileAvatar() {
    final profileImageUrl = _userService.getProfileImageUrl();
    final initial = _userService.getInitial();

    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      // If user has a profile image URL, show it
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(profileImageUrl),
        onBackgroundImageError: (_, __) {
          // Fallback to initial if image fails to load
        },
        child: profileImageUrl.isEmpty
            ? Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      );
    } else if (_userService.isLoggedIn) {
      // If logged in but no image, show initial
      return CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xFFE0B43A),
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      // Default avatar for guest
      return const CircleAvatar(
        radius: 16,
        backgroundImage: AssetImage("assets/images/img3.png"),
      );
    }
  }
}

// ======================================================
// REUSABLE WIDGETS
// ======================================================

// --------------------------
// MODERN ANIMATED NAVBAR
// --------------------------
class _ModernNavBar extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _ModernNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<_ModernNavBar> createState() => _ModernNavBarState();
}

class _ModernNavBarState extends State<_ModernNavBar> with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _scaleControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    _scaleAnimations = _scaleControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();

    // Start animation for initially selected item
    if (widget.selectedIndex < _scaleControllers.length) {
      _scaleControllers[widget.selectedIndex].forward();
    }
  }

  @override
  void didUpdateWidget(_ModernNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      // Reverse old selection animation
      if (oldWidget.selectedIndex < _scaleControllers.length) {
        _scaleControllers[oldWidget.selectedIndex].reverse();
      }
      // Forward new selection animation
      if (widget.selectedIndex < _scaleControllers.length) {
        _scaleControllers[widget.selectedIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2333).withOpacity(0.95),
            const Color(0xFF0F1729).withOpacity(0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE0B43A).withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFFE0B43A).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          final isActive = widget.selectedIndex == index;
          final isCart = item["label"] == "Cart";

          return _AnimatedNavItem(
            icon: item["icon"],
            label: item["label"],
            isActive: isActive,
            isCart: isCart,
            scaleAnimation: _scaleAnimations[index],
            onTap: () {
              widget.onItemTapped(index);
            },
          );
        }),
      ),
    );
  }
}

// --------------------------
// ANIMATED NAV ITEM
// --------------------------
class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCart;
  final Animation<double> scaleAnimation;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCart,
    required this.scaleAnimation,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _tapController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _tapController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    const inactiveColor = Color(0xFF6B7280);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_tapAnimation, widget.scaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _tapAnimation.value * (widget.isActive ? widget.scaleAnimation.value : 1.0),
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isActive ? 16 : 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: widget.isActive
                ? LinearGradient(
                    colors: [
                      gold.withOpacity(0.25),
                      gold.withOpacity(0.1),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            border: widget.isActive
                ? Border.all(color: gold.withOpacity(0.4), width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Icon with glow effect
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect for active state
                  if (widget.isActive)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: gold.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  // Icon
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      widget.isCart 
                          ? (widget.isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined)
                          : widget.icon,
                      key: ValueKey('${widget.label}_${widget.isActive}'),
                      color: widget.isActive ? gold : inactiveColor,
                      size: widget.isCart ? 26 : 24,
                    ),
                  ),
                ],
              ),
              // Animated label (only visible when active)
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: widget.isActive
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                              color: gold,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------
// FEATURED CARD
// --------------------------
class _FeaturedCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;

  const _FeaturedCard({required this.product, this.onTap});

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xff1A1A1A),
            borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                widget.product["image"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(widget.product["name"],
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(widget.product["sub"],
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          Text("\$${widget.product["price"].toStringAsFixed(0)}",
              style: const TextStyle(
                  color: Colors.amber, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}

// --------------------------
// CATEGORY ITEM
// --------------------------
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? const Color(0xFFE0B43A).withOpacity(0.2)
                : const Color(0xff1A1A1A),
            border: isSelected
                ? Border.all(color: const Color(0xFFE0B43A), width: 2)
                : null,
          ),
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFFE0B43A) : Colors.amber,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFE0B43A) : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ]),
    );
  }
}

// --------------------------
// DEAL CARD
// --------------------------
class _DealCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;

  const _DealCard({required this.product, this.onTap});

  @override
  State<_DealCard> createState() => _DealCardState();
}

class _DealCardState extends State<_DealCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(widget.product["image"],
                  height: 80, width: 80, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.product["brand"],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(widget.product["model"],
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Row(children: [
                Text("\$${(widget.product["price"] as double).toStringAsFixed(0)}",
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text("\$${widget.product["oldPrice"]}",
                    style: const TextStyle(
                        color: Colors.white54,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12)),
              ])
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffE0A82F),
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xff0D1628),
            ),
          ),
        ]),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PlaceholderTab({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xff1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.amber, size: 32),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tap Home to return.",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
