import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/screen/meds_detail_screen.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/consume_bottom_sheet.dart'; // <-- Pastikan ini diimport!
import 'package:remindy_app/widgets/home_content_header.dart';
import 'package:remindy_app/widgets/medicine_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Medicine>>(
      valueListenable: globalMedicinesNotifier,
      builder: (context, medicines, child) {
        // KITA FILTER DI SINI: Home HANYA menampilkan obat yang "pending" (belum diminum)
        // Ganti baris filter medicines.where yang lama dengan ini:
        final pendingMedicines = medicines
            .where((m) => !m.isConsumedOn(DateTime.now()))
            .toList();

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: HomeContentHeader()),

              // Cek apakah data PENDING kosong (bukan ngecek medicines keseluruhan)
              if (pendingMedicines.isEmpty)
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
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final medicine =
                          pendingMedicines[index]; // Gunakan data yang sudah difilter!

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: MedicineCard(
                          title: medicine.title,
                          quantity: medicine.quantity,
                          time: medicine.time,
                          isMeal: medicine.isMeal,
                          category: medicine.category,
                          onConsume: () {
                            // Ini yang manggil sheet-nya
                            ConsumeBottomSheet.show(context, medicine.id);
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MedsDetailScreen(medicine: medicine),
                              ),
                            );
                          },
                        ),
                      );
                    }, childCount: pendingMedicines.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
