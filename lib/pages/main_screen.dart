import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'category_screen.dart';
import '../data/auth_database.dart';
import 'cart_screen.dart';
import 'history_screen.dart';

const _green = Color(0xFF00940F);
const _muted = Color(0xFF555555);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    HomeScreen(user: widget.user),
    const CategoryScreen(),
    CartScreen(
      onBack: () {
        setState(() {
          _selectedIndex = 0;
        });
      },
    ),
    const HistoryScreen(),
  ];

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: _BottomNavigation(
        selectedIndex: _selectedIndex,
        onChanged: _onBottomNavTap,
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('Beranda', Icons.home_rounded),
      ('Kategori', Icons.grid_view_outlined),
      ('Keranjang', Icons.shopping_cart_outlined),
      ('Pesanan', Icons.description_outlined),
      ('Akun', Icons.person_outline_rounded),
    ];

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFB6B6B6), width: 0.7)),
      ),
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index++)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[index].$2,
                      size: 23,
                      color: index == selectedIndex ? _green : _muted,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tabs[index].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9,
                        height: 1.1,
                        fontWeight: index == selectedIndex
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: index == selectedIndex ? _green : _muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
