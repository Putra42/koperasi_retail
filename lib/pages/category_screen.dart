import 'package:flutter/material.dart';

const _green = Color(0xFF00940F);
const _ink = Color(0xFF171717);
const _muted = Color(0xFF555555);

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const List<_CategoryItem> categories = [
    _CategoryItem(
      name: 'Beras',
      description: 'Berbagai jenis beras yang\nberkualitas',
      image: 'assets/images/product_rice.png',
    ),
    _CategoryItem(
      name: 'Minyak Goreng',
      description: 'Berbagai jenis minyak yang\nberkualitas',
      image: 'assets/images/product_oil.png',
    ),
    _CategoryItem(
      name: 'Bahan Pokok',
      description: 'Berbagai bahan pokok yang\nberkualitas',
      image: 'assets/images/salt.png',
    ),
    _CategoryItem(
      name: 'Protein',
      description: 'Berbagai jenis protein yang\nberkualitas',
      image: 'assets/images/product_eggs.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const horizontalPadding = 16.0;

            return Column(
              children: [
                // ==========================================================
                // HEADER
                // ==========================================================
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: 12,
                  ),
                  child: const _CategoryHeader(),
                ),

                const SizedBox(height: 18),

                // ==========================================================
                // CATEGORY LIST
                // ==========================================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      20,
                    ),
                    child: Column(
                      children: [
                        for (final category in categories) ...[
                          _CategoryCard(
                            category: category,
                            onTap: () {
                              debugPrint('Kategori dipilih: ${category.name}');
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// CATEGORY ITEM
// ============================================================================

class _CategoryItem {
  final String name;
  final String description;
  final String image;

  const _CategoryItem({
    required this.name,
    required this.description,
    required this.image,
  });
}

// ============================================================================
// HEADER
// ============================================================================

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          // ================================================================
          // BACK ICON
          // Posisi kiri = posisi kiri card
          // ================================================================
          SizedBox(
            width: 24,
            height: 42,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 21,
                  color: _ink,
                ),
              ),
            ),
          ),

          // ================================================================
          // TITLE
          // ================================================================
          const Expanded(
            child: Center(
              child: Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  height: 1.1,
                ),
              ),
            ),
          ),

          // ================================================================
          // SEARCH ICON
          // Posisi kanan = posisi kanan card
          // ================================================================
          SizedBox(
            width: 24,
            height: 42,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                debugPrint('Search kategori');
              },
              child: const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.search_rounded, size: 23, color: _ink),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CATEGORY CARD
// ============================================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final _CategoryItem category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFD0D0D0), width: 0.8),
          ),
          child: Row(
            children: [
              // ============================================================
              // IMAGE
              // ============================================================
              SizedBox(
                width: 58,
                height: 52,
                child: Center(
                  child: Image.asset(
                    category.image,
                    width: 50,
                    height: 46,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        size: 25,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ============================================================
              // TEXT
              // ============================================================
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: _muted,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              // ============================================================
              // CHEVRON
              // ============================================================
              const Icon(Icons.chevron_right_rounded, size: 21, color: _ink),
            ],
          ),
        ),
      ),
    );
  }
}
