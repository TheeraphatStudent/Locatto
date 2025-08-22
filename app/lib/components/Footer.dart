import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  static const Color _indicatorBg = Color(0xFFFFF7F7);
  static const double _iconCircleSize = 40;

  int _selectedIndex = 0;

  Widget _navIcon(String asset, {required bool isSelected, double size = 22}) {
    if (!isSelected) {
      return Opacity(
        opacity: 0.65,
        child: SvgPicture.asset(asset, width: size, height: size),
      );
    }

    return Container(
      width: _iconCircleSize,
      height: _iconCircleSize,
      decoration: const BoxDecoration(
        color: _indicatorBg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Color(0xFFFD5553), BlendMode.srcIn),
        child: SvgPicture.asset(asset, width: size, height: size),
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
      onDestinationSelected: (int index) => setState(() {
        _selectedIndex = index;
      }),
      destinations: <Widget>[
        NavigationDestination(
          icon: _navIcon('assets/images/footer/home.svg', isSelected: false),
          selectedIcon: _navIcon(
            'assets/images/footer/home.svg',
            isSelected: true,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: _navIcon('assets/images/footer/lottery.svg', isSelected: false),
          selectedIcon: _navIcon(
            'assets/images/footer/lottery.svg',
            isSelected: true,
          ),
          label: 'Lottery',
        ),
        NavigationDestination(
          icon: _navIcon('assets/images/footer/cart.svg', isSelected: false),
          selectedIcon: _navIcon(
            'assets/images/footer/cart.svg',
            isSelected: true,
          ),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: _navIcon('assets/images/footer/pocket.svg', isSelected: false),
          selectedIcon: _navIcon(
            'assets/images/footer/pocket.svg',
            isSelected: true,
          ),
          label: 'Wallet',
        ),
        NavigationDestination(
          icon: _navIcon('assets/images/footer/profile.svg', isSelected: false),
          selectedIcon: _navIcon(
            'assets/images/footer/profile.svg',
            isSelected: true,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
