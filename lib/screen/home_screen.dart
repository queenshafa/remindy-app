import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/home_content_header.dart';
import 'package:remindy_app/widgets/medicine_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Medicine> medicines = dummyMedicines;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: HomeContentHeader()),

          if (medicines.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No medications scheduled',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              ),
            )
          else
            SliverPadding(
              // Padding bottom 120px agar konten obat paling bawah tidak tertutup navbar
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final medicine = medicines[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: MedicineCard(
                      title: medicine.title,
                      quantity: medicine.quantity,
                      time: medicine.time,
                      isMeal: medicine.isMeal,
                      category: medicine.category,
                      onTap: () {},
                    ),
                  );
                }, childCount: medicines.length),
              ),
            ),
        ],
      ),
    );
  }
}
