import 'package:flutter/material.dart';
import 'checkout_screen.dart';

const _green = Color(0xFF00940F);
const _ink = Color(0xFF171717);
const _muted = Color(0xFF555555);
const _border = Color(0xFFD0D0D0);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // =========================================================================
  // CART DATA
  // =========================================================================

  final List<_CartItem> _items = [
    _CartItem(
      name: 'Beras Premium',
      price: 75000,
      quantity: 1,
      image: 'assets/images/product_rice.png',
    ),
    _CartItem(
      name: '20 Butir Telur',
      price: 40000,
      quantity: 1,
      image: 'assets/images/product_eggs.png',
    ),
    _CartItem(
      name: 'Minyak Bimoli',
      price: 34000,
      quantity: 1,
      image: 'assets/images/product_oil.png',
    ),
  ];

  // =========================================================================
  // CALCULATION
  // =========================================================================

  int get subtotal {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get discount {
    // Untuk sekarang belum ada diskon.
    return 0;
  }

  int get tax {
    // Mengikuti contoh UI kamu:
    // Rp 250.000 → pajak Rp 2.500 = 1%
    return ((subtotal - discount) * 0.01).round();
  }

  int get total {
    return subtotal - discount + tax;
  }

  // =========================================================================
  // QUANTITY
  // =========================================================================

  void _increaseQuantity(int index) {
    setState(() {
      _items[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    if (_items[index].quantity <= 1) {
      return;
    }

    setState(() {
      _items[index].quantity--;
    });
  }

  // =========================================================================
  // DELETE
  // =========================================================================

  void _removeItem(int index) {
    final removedItem = _items[index];

    setState(() {
      _items.removeAt(index);
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedItem.name} dihapus dari keranjang'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // =========================================================================
  // RUPIAH FORMAT
  // =========================================================================

  String _rupiah(int value) {
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return 'Rp. $formatted';
  }

  // =========================================================================
  // CHECKOUT
  // =========================================================================

  void _checkout() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keranjang masih kosong')));

      return;
    }

    final checkoutItems = _items.map((item) {
      return CheckoutItem(
        name: item.name,
        price: item.price,
        quantity: item.quantity,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          items: checkoutItems,
          subtotal: subtotal,
          discount: discount,
          tax: tax,
          total: total,
        ),
      ),
    );
  }

  // =========================================================================
  // BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================================
            // HEADER
            // =================================================================
            _CartHeader(onBack: widget.onBack),

            // =================================================================
            // PRODUCT LIST
            //
            // HANYA BAGIAN INI YANG BOLEH SCROLL
            // =================================================================
            Expanded(
              child: _items.isEmpty
                  ? const _EmptyCart()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 9, 16, 10),
                      itemCount: _items.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 13);
                      },
                      itemBuilder: (context, index) {
                        final item = _items[index];

                        return _CartProductCard(
                          item: item,
                          onMinus: () {
                            _decreaseQuantity(index);
                          },
                          onPlus: () {
                            _increaseQuantity(index);
                          },
                          onDelete: () {
                            _removeItem(index);
                          },
                          rupiah: _rupiah,
                        );
                      },
                    ),
            ),

            // =================================================================
            // SUMMARY
            //
            // BAGIAN INI TIDAK IKUT SCROLL
            // =================================================================
            _CartSummary(
              subtotal: subtotal,
              discount: discount,
              tax: tax,
              total: total,
              rupiah: _rupiah,
              onCheckout: _checkout,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// CART ITEM MODEL
// =============================================================================

class _CartItem {
  _CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  final String name;
  final int price;
  int quantity;
  final String image;
}

// =============================================================================
// HEADER
// =============================================================================

class _CartHeader extends StatelessWidget {
  const _CartHeader({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            // BACK
            SizedBox(
              width: 24,
              height: 40,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onBack,
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
                  'Keranjang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    height: 1,
                  ),
                ),
              ),
            ),

            // SPACER
            const SizedBox(width: 24, height: 40),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PRODUCT CARD
// =============================================================================

class _CartProductCard extends StatelessWidget {
  const _CartProductCard({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onDelete,
    required this.rupiah,
  });

  final _CartItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDelete;
  final String Function(int) rupiah;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _border, width: 0.8),
      ),
      child: Row(
        children: [
          // ===================================================================
          // PRODUCT IMAGE
          // ===================================================================
          SizedBox(
            width: 54,
            height: 68,
            child: Center(
              child: Image.asset(
                item.image,
                width: 48,
                height: 62,
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

          const SizedBox(width: 7),

          // ===================================================================
          // PRODUCT INFORMATION
          // ===================================================================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
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
                  rupiah(item.price),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 5),

                // QUANTITY
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SmallQuantityButton(
                      icon: Icons.remove_rounded,
                      onTap: onMinus,
                    ),

                    Container(
                      width: 32,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: _border, width: 0.7),
                          bottom: BorderSide(color: _border, width: 0.7),
                        ),
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _ink,
                        ),
                      ),
                    ),

                    _SmallQuantityButton(
                      icon: Icons.add_rounded,
                      onTap: onPlus,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===================================================================
          // DELETE
          // ===================================================================
          SizedBox(
            width: 28,
            height: 40,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDelete,
              child: const Center(
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: _muted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SMALL QUANTITY BUTTON
// =============================================================================

class _SmallQuantityButton extends StatelessWidget {
  const _SmallQuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 20,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          side: const BorderSide(color: _border, width: 0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(icon, size: 11, color: _ink),
      ),
    );
  }
}

// =============================================================================
// EMPTY CART
// =============================================================================

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 50,
            color: Color(0xFFAAAAAA),
          ),
          SizedBox(height: 10),
          Text(
            'Keranjang masih kosong',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CART SUMMARY
// =============================================================================

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.rupiah,
    required this.onCheckout,
  });

  final int subtotal;
  final int discount;
  final int tax;
  final int total;
  final String Function(int) rupiah;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border, width: 0.8)),
      ),
      child: Column(
        children: [
          // =================================================================
          // SUBTOTAL
          // =================================================================
          _SummaryRow(label: 'Subtotal', value: rupiah(subtotal)),

          const SizedBox(height: 2),

          // =================================================================
          // DISKON
          // =================================================================
          _SummaryRow(label: 'Diskon', value: rupiah(discount)),

          const SizedBox(height: 2),

          // =================================================================
          // PAJAK
          // =================================================================
          _SummaryRow(label: 'Pajak', value: rupiah(tax)),

          const SizedBox(height: 6),

          // =================================================================
          // TOTAL
          // =================================================================
          _SummaryRow(label: 'Total', value: rupiah(total), bold: true),

          const SizedBox(height: 7),

          // =================================================================
          // CHECKOUT
          // =================================================================
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: onCheckout,
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
                'Checkout',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SUMMARY ROW
// =============================================================================

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 12 : 10,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: _ink,
            height: 1.1,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 12 : 10,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: _ink,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
