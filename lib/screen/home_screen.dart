import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/screen/meds_detail_screen.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/consume_bottom_sheet.dart';
import 'package:remindy_app/widgets/home_content_header.dart';
import 'package:remindy_app/widgets/medicine_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<List<Medicine>>(
          valueListenable: globalMedicinesNotifier,
          builder: (context, medicines, child) {
            // 👇 FILTER BARU: Belum Diminum HARI INI & Masuk Jadwal HARI INI 👇
            final DateTime today = DateTime.now();
            final pendingMedicines = medicines
                .where(
                  (m) =>
                      !m.isConsumedOn(today) &&
                      m.isScheduledForDate(
                        today,
                      ), // Cek intervalnya masuk ke hari ini nggak
                )
                .toList();
            // 👆 SELESAI 👆

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: HomeContentHeader()),

                  if (pendingMedicines.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No medications scheduled for today',
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
                          final medicine = pendingMedicines[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: MedicineCard(
                              title: medicine.title,
                              quantity: medicine.quantity,
                              time: medicine.time,
                              instruction: medicine
                                  .totalDosage, // <-- Menggunakan teks instruksi asli
                              category: medicine.category,
                              onConsume: () {
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
        ),
      ),
    );
  }
}
