import 'package:flutter/material.dart';

const _green = Color(0xFF00940F);
const _lightGreen = Color(0xFFE6F7E4);
const _ink = Color(0xFF171717);
const _muted = Color(0xFF555555);
const _border = Color(0xFFCFCFCF);

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
  });

  final List<CheckoutItem> items;
  final int subtotal;
  final int discount;
  final int tax;
  final int total;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPayment;

  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // =========================================================================
  // RUPIAH
  // =========================================================================

  String _rupiah(int value) {
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return 'Rp. $formatted';
  }

  // =========================================================================
  // PAYMENT
  // =========================================================================

  void _selectPayment(String payment) {
    setState(() {
      _selectedPayment = payment;
    });
  }

  // =========================================================================
  // CREATE ORDER
  // =========================================================================

  void _createOrder() {
    if (_selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih metode pembayaran')),
      );

      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat')));
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
            _CheckoutHeader(
              onBack: () {
                Navigator.pop(context);
              },
            ),

            // =================================================================
            // RINGKASAN BELANJA
            // =================================================================
            _ShoppingSummary(
              items: widget.items,
              subtotal: widget.subtotal,
              discount: widget.discount,
              tax: widget.tax,
              total: widget.total,
              rupiah: _rupiah,
            ),

            const SizedBox(height: 4),

            // =================================================================
            // PAYMENT + SCROLL AREA
            // =================================================================
            //
            // Bagian ini yang bisa scroll.
            //
            // Kalau metode pembayaran bertambah banyak, bagian ini
            // bisa digeser tanpa menggerakkan header, ringkasan,
            // catatan, dan tombol Buat Pesanan.
            //
            // =================================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PaymentSection(
                  selectedPayment: _selectedPayment,
                  onSelect: _selectPayment,
                ),
              ),
            ),

            // =================================================================
            // CATATAN
            // =================================================================
            _CheckoutNote(controller: _noteController),

            // =================================================================
            // BUTTON BUAT PESANAN
            // =================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 8),
              child: SizedBox(
                width: double.infinity,
                height: 34,
                child: ElevatedButton(
                  onPressed: _createOrder,
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
                    'Buat Pesanan',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// CHECKOUT HEADER
// =============================================================================

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 9, 16, 4),
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 34,
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

            const Expanded(
              child: Center(
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    height: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 20, height: 34),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SHOPPING SUMMARY
// =============================================================================

class _ShoppingSummary extends StatelessWidget {
  const _ShoppingSummary({
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.rupiah,
  });

  final List<CheckoutItem> items;
  final int subtotal;
  final int discount;
  final int tax;
  final int total;
  final String Function(int) rupiah;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          const Text(
            'Ringkasan Belanja',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),

          const SizedBox(height: 8),

          // PRODUCTS
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: _ink,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    rupiah(item.total),
                    style: const TextStyle(
                      fontSize: 10,
                      color: _ink,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 4),

          const Divider(height: 1, thickness: 0.7, color: _border),

          const SizedBox(height: 5),

          _CheckoutSummaryRow(label: 'Subtotal', value: rupiah(subtotal)),

          const SizedBox(height: 3),

          _CheckoutSummaryRow(label: 'Diskon', value: rupiah(discount)),

          const SizedBox(height: 3),

          _CheckoutSummaryRow(label: 'Pajak', value: rupiah(tax)),

          const SizedBox(height: 6),

          _CheckoutSummaryRow(label: 'Total', value: rupiah(total), bold: true),
        ],
      ),
    );
  }
}

// =============================================================================
// SUMMARY ROW
// =============================================================================

class _CheckoutSummaryRow extends StatelessWidget {
  const _CheckoutSummaryRow({
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


class _PaymentSection extends StatelessWidget {
  const _PaymentSection({
    required this.selectedPayment,
    required this.onSelect,
  });

  final String? selectedPayment;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _border, width: 0.8),
      ),
      padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _ink,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _PaymentOption(
                  title: 'Bayar di Kasir',
                  selected: selectedPayment == 'Bayar di Kasir',
                  onTap: () => onSelect('Bayar di Kasir'),
                ),
                const SizedBox(height: 4),
                _PaymentOption(
                  title: 'Qris',
                  selected: selectedPayment == 'Qris',
                  onTap: () => onSelect('Qris'),
                ),
                const SizedBox(height: 4),
                _PaymentOption(
                  title: 'Transfer',
                  selected: selectedPayment == 'Transfer',
                  onTap: () => onSelect('Transfer'),
                ),
                const SizedBox(height: 4),
                _PaymentOption(
                  title: 'E-Wallet',
                  selected: selectedPayment == 'E-Wallet',
                  onTap: () => onSelect('E-Wallet'),
                ),
                const SizedBox(height: 4),
                _PaymentOption(
                  title: 'Debit / Kartu',
                  selected: selectedPayment == 'Debit / Kartu',
                  onTap: () => onSelect('Debit / Kartu'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PAYMENT OPTION
// =============================================================================

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFDDF5D9) : _lightGreen,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: double.infinity,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 17,
                color: _green,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// NOTE
// =============================================================================

class _CheckoutNote extends StatelessWidget {
  const _CheckoutNote({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan (Opsional)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),

          const SizedBox(height: 6),

          SizedBox(
            height: 35,
            child: TextField(
              controller: controller,
              maxLines: 2,
              style: const TextStyle(fontSize: 8, color: _ink),
              decoration: InputDecoration(
                hintText: 'Tulis catatan untuk pesanan anda...',
                hintStyle: const TextStyle(fontSize: 8, color: _muted),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: _border, width: 0.8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: _border, width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: _green, width: 1),
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
// CHECKOUT ITEM
// =============================================================================

class CheckoutItem {
  const CheckoutItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String name;
  final int price;
  final int quantity;

  int get total => price * quantity;
}
