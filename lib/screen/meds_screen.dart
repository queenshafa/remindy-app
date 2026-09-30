import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/meds_header.dart';
import 'package:remindy_app/widgets/meds_list_section.dart';

class MedsScreen extends StatefulWidget {
  const MedsScreen({super.key});

  @override
  State<MedsScreen> createState() => _MedsScreenState();
}

class _MedsScreenState extends State<MedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MedsHeader(),

            // Dengarkan perubahan pada Kalender
            ValueListenableBuilder<DateTime>(
              valueListenable: globalSelectedDateNotifier,
              builder: (context, selectedDate, child) {
                // Dengarkan perubahan pada List Obat
                return ValueListenableBuilder<List<Medicine>>(
                  valueListenable: globalMedicinesNotifier,
                  builder: (context, allMedicines, child) {
                    // Filter: Belum diminum DI TANGGAL YANG DIPILIH
                    final medsToTake = allMedicines
                        .where((m) => !m.isConsumedOn(selectedDate))
                        .toList();

                    // Filter: Sudah diminum DI TANGGAL YANG DIPILIH
                    final medsTaken = allMedicines
                        .where((m) => m.isConsumedOn(selectedDate))
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          MedsListSection(
                            title: 'Meds to Take',
                            medicines: medsToTake,
                            isCompletedSection: false, // Tombol AKTIF
                          ),

                          const SizedBox(height: 16),

                          MedsListSection(
                            title: 'Meds Taken',
                            medicines: medsTaken,
                            isCompletedSection: true, // Tombol HILANG
                          ),

                          const SizedBox(height: 120),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
