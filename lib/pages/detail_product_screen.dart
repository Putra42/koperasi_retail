import 'package:flutter/material.dart';

const _green = Color(0xFF00940F);
const _ink = Color(0xFF171717);
const _muted = Color(0xFF555555);

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({
    super.key,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.netto,
    required this.image,
  });

  final String name;
  final String price;
  final int stock;
  final String description;
  final String netto;
  final String image;

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  int _quantity = 1;
  bool _favorite = false;

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _increaseQuantity() {
    if (_quantity < widget.stock) {
      setState(() {
        _quantity++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // HEADER
            // ============================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: SizedBox(
                height: 34,
                child: Row(
                  children: [
                    // BACK
                    SizedBox(
                      width: 24,
                      height: 34,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: _ink,
                          ),
                        ),
                      ),
                    ),

                    // TITLE
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Detail Produk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                            height: 1,
                          ),
                        ),
                      ),
                    ),

                    // FAVORITE
                    SizedBox(
                      width: 24,
                      height: 34,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _favorite = !_favorite;
                          });
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            _favorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 19,
                            color: _favorite ? _green : _ink,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ============================================================
            // CONTENT
            // ============================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======================================================
                    // PRODUCT IMAGE
                    // ======================================================
                    SizedBox(
                      width: double.infinity,
                      height: 158,
                      child: Center(
                        child: Image.asset(
                          widget.image,
                          width: 110,
                          height: 150,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                              size: 45,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),

                    // ======================================================
                    // NAME
                    // ======================================================
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 11),

                    // ======================================================
                    // PRICE
                    // ======================================================
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _green,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ======================================================
                    // STOCK
                    // ======================================================
                    Text(
                      'Stok tersedia: ${widget.stock}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: _muted,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 13),

                    // ======================================================
                    // DESCRIPTION
                    // ======================================================
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 9,
                        color: _muted,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Netto: ${widget.netto}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: _muted,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ======================================================
                    // JUMLAH
                    // ======================================================
                    const Text(
                      'Jumlah',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // QUANTITY
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QuantityButton(
                          icon: Icons.remove_rounded,
                          onTap: _decreaseQuantity,
                        ),

                        Container(
                          width: 68,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFD0D0D0),
                                width: 0.7,
                              ),
                              bottom: BorderSide(
                                color: Color(0xFFD0D0D0),
                                width: 0.7,
                              ),
                            ),
                          ),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                        ),

                        _QuantityButton(
                          icon: Icons.add_rounded,
                          onTap: _increaseQuantity,
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    // ======================================================
                    // ADD TO CART
                    // ======================================================
                    SizedBox(
                      width: 196,
                      height: 33,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.name} ditambahkan ke keranjang',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Tambah ke Keranjang',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ================================================================
      // BOTTOM NAVIGATION
      // ================================================================
      bottomNavigationBar: const _DetailBottomNavigation(),
    );
  }
}

// ============================================================================
// QUANTITY BUTTON
// ============================================================================

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 26,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          side: const BorderSide(color: Color(0xFFD0D0D0), width: 0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Icon(icon, size: 14, color: _ink),
      ),
    );
  }
}

// ============================================================================
// BOTTOM NAVIGATION
// ============================================================================

class _DetailBottomNavigation extends StatelessWidget {
  const _DetailBottomNavigation();

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
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFB6B6B6), width: 0.7)),
      ),
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index++)
            Expanded(
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tabs[index].$2, size: 23, color: _muted),
                    const SizedBox(height: 2),
                    Text(
                      tabs[index].$1,
                      style: const TextStyle(
                        fontSize: 9,
                        height: 1.1,
                        fontWeight: FontWeight.w500,
                        color: _muted,
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
