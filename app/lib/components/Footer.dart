import 'package:flutter/material.dart';
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
  NavItem(route: '/cart', iconName: 'cart', label: 'Cart'),
  NavItem(route: '/purchase', iconName: 'pocket', label: 'Wallet'),
  NavItem(route: '/profile', iconName: 'profile', label: 'Profile'),
];

/// Admin navigation configuration
const List<NavItem> adminNavItems = [
  NavItem(route: '/home', iconName: 'logo', label: 'Home'),
  NavItem(route: '/profile', iconName: 'profile', label: 'Profile'),
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

  List<NavItem> get _navItems =>
      _userRole == 'admin' ? adminNavItems : userNavItems;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
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

    final index = _navItems.indexWhere((item) => item.route == currentRoute);
    setState(() {
      _selectedIndex = index >= 0 ? index : 0;
    });
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex == index) return;

    setState(() => _selectedIndex = index);
    Navigator.pushNamed(context, _navItems[index].route);
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
