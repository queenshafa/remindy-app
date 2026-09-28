import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart'; // Sesuaikan lokasi data kamu
import 'package:remindy_app/models/medicine.dart'; // Sesuaikan model kamu
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/home_content_header.dart';
import 'package:remindy_app/widgets/medicine_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data obat dari dummy
    final List<Medicine> medicines = dummyMedicines;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: HomeContentHeader()),
            // If no meds data availble
            if (medicines.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No medications scheduled',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              // Meds Card
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
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
                        onTap: () {
                          // Action saat tombol / card diklik
                        },
                      ),
                    );
                  }, childCount: medicines.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
