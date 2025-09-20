import 'package:flutter/material.dart';

class AdminFooter extends StatefulWidget {
  const AdminFooter({super.key});

  @override
  State<AdminFooter> createState() => _AdminFooterState();
}

class _AdminFooterState extends State<AdminFooter> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    if (_selectedIndex == index) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = '/admin/adminHome'; // หน้าแรกของ Admin
        break;
      case 1:
        routeName = '/admin/adminProfile'; // หน้าโปรไฟล์ของ Admin
        break;
      default:
        routeName = '/admin/adminHome';
    }

    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushNamed(context, routeName); // สลับหน้า
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
      ),
    );
  }

  void _updateSelectedIndexFromRoute() {
    final String currentRoute =
        ModalRoute.of(context)?.settings.name ?? '/admin/adminHome';

    switch (currentRoute) {
      case '/admin/adminHome':
        _selectedIndex = 0;
        break;
      case '/admin/adminProfile':
        _selectedIndex = 1;
        break;
      default:
        _selectedIndex = 0;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndexFromRoute();
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
      destinations: <Widget>[
        NavigationDestination(
          icon: _buildInactiveIcon('logo'),
          selectedIcon: _buildActiveIcon('logo'),
          label: 'Home',
        ),
        NavigationDestination(
          icon: _buildInactiveIcon('profile'),
          selectedIcon: _buildActiveIcon('profile'),
          label: 'Profile',
        ),
      ],
    );
  }
}
