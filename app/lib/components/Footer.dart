import 'package:flutter/material.dart';
// Note: flutter_svg is no longer used in this widget.
// import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

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

  //  Widget _buildActiveIcon(String iconName) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Image.asset(
  //       'assets/images/footer/active/$iconName.png',
  //       width: 28,
  //       height: 28,
  //       errorBuilder: (context, error, stackTrace) {
  //         return Container(
  //           width: 28,
  //           height: 28,
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFFD5553),
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: const Icon(Icons.error_outline, size: 20, color: Colors.white),
  //         );
  //       },
  //     ),
  //   );
  // }

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
      onDestinationSelected: (int index) => setState(() {
        _selectedIndex = index;
      }),
      destinations: <Widget>[
        NavigationDestination(
          icon: _buildInactiveIcon('logo'),
          selectedIcon: _buildActiveIcon('logo'),
          label: 'Home',
        ),
        NavigationDestination(
          icon: _buildInactiveIcon('lottery'),
          selectedIcon: _buildActiveIcon('lottery'),
          label: 'Lottery',
        ),
        NavigationDestination(
          icon: _buildInactiveIcon('cart'),
          selectedIcon: _buildActiveIcon('cart'),
          label: 'Cart',
        ),
        NavigationDestination(
          // Assuming 'pocket.png' is for the 'Wallet' label
          icon: _buildInactiveIcon('pocket'),
          selectedIcon: _buildActiveIcon('pocket'),
          label: 'Wallet',
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
