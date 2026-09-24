import 'package:flutter/material.dart';

const _green = Color(0xFF00940F);
const _ink = Color(0xFF171717);
const _muted = Color(0xFF777777);
const _border = Color(0xFFCFCFCF);
const _orange = Color(0xFFF59A23);

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedStatus = 0;

  static const _statuses = ['Semua', 'Diproses', 'Siap Diambil', 'Selesai'];

  final _orders = const [
    _Order(number: '#TRX240601001', status: 'Siap Diambil'),
    _Order(number: '#TRX240601001', status: 'Siap Diambil'),
    _Order(number: '#TRX240601001', status: 'Siap Diambil'),
    _Order(number: '#TRX240601001', status: 'Siap Diambil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _HistoryHeader(),
            _StatusTabs(
              selectedIndex: _selectedStatus,
              statuses: _statuses,
              onChanged: (index) {
                setState(() => _selectedStatus = index);
              },
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 17, 16, 12),
                itemCount: _orders.length,
                separatorBuilder: (_, index) => const SizedBox(height: 7),
                itemBuilder: (context, index) =>
                    _OrderCard(order: _orders[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  'Riwayat Pesanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({
    required this.selectedIndex,
    required this.statuses,
    required this.onChanged,
  });

  final int selectedIndex;
  final List<String> statuses;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 29,
        child: Row(
          children: [
            for (var index = 0; index < statuses.length; index++)
              Expanded(
                child: InkWell(
                  onTap: () => onChanged(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        statuses[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: index == selectedIndex
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: index == selectedIndex ? _green : _ink,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        height: index == selectedIndex ? 1.5 : 0.7,
                        color: index == selectedIndex ? _green : _border,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final _Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.number,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    height: 1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D9),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    fontSize: 7,
                    color: _orange,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            '01 Jun 2024 - 10:30',
            style: TextStyle(fontSize: 8, color: _muted, height: 1),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Expanded(
                child: Text(
                  '3 item',
                  style: TextStyle(fontSize: 8, color: _muted, height: 1),
                ),
              ),
              const Text(
                'Rp. 137.000',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Lihat Detail',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: _green,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Order {
  const _Order({required this.number, required this.status});

  final String number;
  final String status;
}
