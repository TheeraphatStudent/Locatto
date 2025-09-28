import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:app/service/user.dart';

/// A navigation item model
class NavItem {
  final String route;
  final String iconName;
  final String label;

  const NavItem({
    required this.route,
    required this.iconName,
    required this.label,
  });
}

/// User navigation configuration
const List<NavItem> userNavItems = [
  NavItem(route: '/home', iconName: 'logo', label: 'Home'),
  NavItem(route: '/lottery', iconName: 'lottery', label: 'Lottery'),
  // NavItem(route: '/cart', iconName: 'cart', label: 'Cart'),
  NavItem(route: '/purchase', iconName: 'pocket', label: 'Wallet'),
  NavItem(route: '/profile', iconName: 'profile', label: 'Profile'),
];

/// Admin navigation configuration
const List<NavItem> adminNavItems = [
  NavItem(route: '/adminHome', iconName: 'logo', label: 'Home'),
  NavItem(route: '/adminProfile', iconName: 'profile', label: 'Profile'),
];

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;
  final UserService _userService = UserService();
  String _userRole = 'user';
  bool _isNavigating = false;

  List<NavItem> get _navItems =>
      _userRole == 'admin' ? adminNavItems : userNavItems;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected index whenever the route changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add a small delay to ensure route is fully loaded
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _updateSelectedIndexFromRoute();
        }
      });
    });
  }

  Future<void> _loadUserRole() async {
    final role = await _userService.getUserRole();
    if (role != null && mounted) {
      setState(() => _userRole = role);
      _updateSelectedIndexFromRoute();
    }
  }

  void _updateSelectedIndexFromRoute() {
    final String currentRoute =
        ModalRoute.of(context)?.settings.name ?? '/home';

    log('Current route: $currentRoute, User role: $_userRole');
    log('Available nav items: ${_navItems.map((e) => e.route).toList()}');

    final index = _navItems.indexWhere((item) => item.route == currentRoute);

    log('Found index: $index for route: $currentRoute');

    if (index >= 0 && index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index < 0) {
      if (_userRole == 'admin' &&
          currentRoute.toLowerCase().contains('profile')) {
        final profileIndex = _navItems.indexWhere(
          (item) => item.route == '/adminProfile',
        );
        if (profileIndex >= 0) {
          setState(() {
            _selectedIndex = profileIndex;
          });
        }
      }
    }
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex == index) return;

    if (_isNavigating) return;
    _isNavigating = true;

    setState(() => _selectedIndex = index);

    final targetRoute = _navItems[index].route;
    log('Navigating to: $targetRoute');

    Navigator.of(context)
        .pushNamedAndRemoveUntil(targetRoute, (route) => false)
        .then((_) {
          _isNavigating = false;
          // Add delay to ensure route is fully loaded before checking
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              _updateSelectedIndexFromRoute();
            }
          });
        })
        .catchError((error) {
          log('Navigation error: $error');
          _isNavigating = false;
          // Reset selected index on error
          _updateSelectedIndexFromRoute();
        });
  }

  Widget _buildInactiveIcon(String iconName) {
    return Image.asset(
      'assets/images/footer/inactive/$iconName.png',
      width: 24,
      height: 24,
    );
  }

  Widget _buildActiveIcon(String iconName) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/footer/active/$iconName.png',
          width: 28,
          height: 28,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFFD5553),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 20,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      backgroundColor: const Color(0xFF9C8E8E),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      indicatorColor: Colors.transparent,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: _navItems.map((item) {
        return NavigationDestination(
          icon: _buildInactiveIcon(item.iconName),
          selectedIcon: _buildActiveIcon(item.iconName),
          label: item.label,
        );
      }).toList(),
    );
  }
}
