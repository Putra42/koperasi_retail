import 'package:flutter/material.dart';

import '../data/auth_database.dart';
import 'welcome_screen.dart';
import 'detail_product_screen.dart';

const _green = Color(0xFF00940F);
const _ink = Color(0xFF171717);
const _muted = Color(0xFF555555);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  Future<void> _selectTab(int index) async {
    setState(() => _selectedTab = index);
    if (index != 4) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.user.identifier,
                style: const TextStyle(fontSize: 14, color: _muted),
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout_rounded, color: _green),
                title: const Text('Keluar dari akun'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await AuthDatabase.instance.signOut();
                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (_) => false,
                  );
                },
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const horizontalPadding = 16.0;
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      17,
                      horizontalPadding,
                      12,
                    ),
                    child: SizedBox(
                      width: constraints.maxWidth - (horizontalPadding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Header(user: widget.user),
                          const SizedBox(height: 18),
                          const _PromoBanner(),
                          const SizedBox(height: 25),
                          const _SectionHeading(title: 'Kategori'),
                          const SizedBox(height: 11),
                          const _CategoryRow(),
                          const SizedBox(height: 18),
                          const _SectionHeading(title: 'Produk Terlaris'),
                          const SizedBox(height: 11),
                          const _ProductGrid(),
                        ],
                      ),
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
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${user.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Anggota · ${user.identifier}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _muted,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Belum ada notifikasi baru.')),
            ),
            visualDensity: VisualDensity.compact,
            tooltip: 'Notifikasi',
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 22,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 367 / 203,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = constraints.maxWidth / 349;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Transform.scale(
                    scale: 1.07, // hilangkan area transparan di kanan & bawah
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 20 * scale,
                    top: 18 * scale,
                    right: 106 * scale,
                    child: Text(
                      'Belanja Sembako\nLebih Hemat\ndi Koperasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17 * scale,
                        height: .98,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18 * scale,
                    bottom: 16 * scale,
                    child: Text(
                      'Periode 1-30 Juli 2024',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7 * scale,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _ink,
              height: 1.15,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: _green,
            ),
            child: const Text(
              'Lihat Semua',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    const categories = [
      ('Beras', 'assets/images/product_rice.png'),
      ('Minyak\nGoreng', 'assets/images/product_oil.png'),
      ('Bahan\nPokok', null),
      ('Protein', 'assets/images/product_eggs.png'),
    ];
    return Row(
      children: [
        for (final category in categories)
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: Center(
                    child: category.$2 == null
                        ? const _SaltPack()
                        : Image.asset(
                            category.$2!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.$1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.05,
                    fontWeight: FontWeight.w500,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SaltPack extends StatelessWidget {
  const _SaltPack();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 37,
      padding: const EdgeInsets.only(top: 3, bottom: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F2),
        border: Border.all(color: const Color(0xFFC9C9BD), width: .7),
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(height: 4, color: const Color(0xFF77A638)),
          const Text(
            'GARAM',
            style: TextStyle(
              fontSize: 5,
              height: 1,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const Icon(Icons.eco_rounded, size: 9, color: _green),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    const products = [
      (
        'Beras Premium',
        '5 kg',
        'Rp. 75.000',
        'assets/images/product_rice.png',
        30,
        'Beras pilihan berkualitas premium, pulen, bersih, dan higienis.',
      ),
      (
        'Minyak Goreng',
        '2 L',
        'Rp. 34.000',
        'assets/images/product_oil.png',
        25,
        'Minyak goreng berkualitas untuk kebutuhan memasak sehari-hari.',
      ),
      (
        'Telur ayam',
        '20 Butir',
        'Rp. 40.000',
        'assets/images/product_eggs.png',
        20,
        'Telur ayam segar dan berkualitas untuk kebutuhan keluarga.',
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < products.length; index++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == products.length - 1 ? 0 : 9,
              ),
              child: _ProductCard(
                product: products[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailProductScreen(
                        name: products[index].$1,
                        price: products[index].$3,
                        stock: products[index].$5,
                        description: products[index].$6,
                        netto: products[index].$2,
                        image: products[index].$4,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final (String, String, String, String, int, String) product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 66,
            child: Center(
              child: Image.asset(
                product.$4,
                width: double.infinity,
                height: 64,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            product.$1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              height: 1.1,
              fontWeight: FontWeight.w500,
              color: _ink,
            ),
          ),

          Text(
            product.$2,
            style: const TextStyle(fontSize: 9, height: 1.2, color: _muted),
          ),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              product.$3,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
            ),
          ),
        ],
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
        border: Border(top: BorderSide(color: Color(0xFFB6B6B6), width: .7)),
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
