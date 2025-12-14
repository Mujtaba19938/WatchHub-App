import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
import '../cart/cart_screen.dart';
import '../widgets/app_gradient_bg.dart';
import 'my_addresses_screen.dart';
import 'order_history_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'faq_screen.dart';
import '../services/user_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();

  static const List<Map<String, dynamic>> _navItems = [
    {"icon": Icons.home, "label": "Home"},
    {"icon": Icons.search, "label": "Discover"},
    {"icon": Icons.favorite_border, "label": "Wishlist"},
    {"icon": Icons.shopping_cart_outlined, "label": "Cart"},
  ];

  int _selectedIndex = 2;

  void _handleNavTap(BuildContext context, String label) {
    if (label == "Home") {
      Navigator.of(context).pop();
      return;
    }
    if (label == "Cart") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
      return;
    }
    if (label == "Wishlist") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => WishlistScreen()),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label coming soon"),
        duration: const Duration(seconds: 1),
      ),
    );
    setState(() => _selectedIndex =
        _navItems.indexWhere((element) => element["label"] == label));
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF0F1729); // dark block behind menu + logout

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0E1525),
              Color(0xFF0A0F1A),
            ],
          ),
        ),
        child: Row(
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            return Expanded(
              child: _NavItem(
                icon: item["icon"],
                label: item["label"],
                active: _selectedIndex == index,
                onTap: () => _handleNavTap(context, item["label"]),
              ),
            );
          }),
        ),
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TITLE
                const Text(
                  "My Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 22),

                // AVATAR
                _buildProfileAvatar(),

                const SizedBox(height: 16),

                // NAME
                Text(
                  _userService.isLoggedIn
                      ? _userService.getDisplayName()
                      : "Guest",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // EMAIL
                Text(
                  _userService.isLoggedIn && _userService.getEmail().isNotEmpty
                      ? _userService.getEmail()
                      : "Not logged in",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                // MAIN CARD (MENU ITEMS)
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.edit_outlined,
                        label: "Edit Profile",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.map_outlined,
                        label: "My Addresses",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MyAddressesScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.favorite_border,
                        label: "Wishlist",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WishlistScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.shopping_bag_outlined,
                        label: "Order History",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OrderHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        label: "Settings",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FAQScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // LOGOUT ROW
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: InkWell(
                    onTap: () async {
                      await _userService.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.redAccent, size: 20),
                        SizedBox(width: 12),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // separator line inside the card
  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  // Build profile avatar
  Widget _buildProfileAvatar() {
    try {
      if (!_userService.isLoggedIn) {
        // Default avatar for guest
        return const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/images/img3.png"),
        );
      }

      final profileImageUrl = _userService.getProfileImageUrl();
      final initial = _userService.getInitial();

      if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
        // If user has a profile image URL, show it
        return CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(profileImageUrl),
          onBackgroundImageError: (_, __) {
            // Fallback to initial if image fails to load
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFE0B43A),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        // If logged in but no image, show initial
        return CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFFE0B43A),
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    } catch (e) {
      // Fallback to default avatar on error
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage("assets/images/img3.png"),
      );
    }
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem(
      {required this.icon,
      required this.label,
      this.active = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? Colors.amber : Colors.white54),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.amber : Colors.white54,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
