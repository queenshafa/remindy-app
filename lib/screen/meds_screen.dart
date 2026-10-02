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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MedsHeader(),

              ValueListenableBuilder<DateTime>(
                valueListenable: globalSelectedDateNotifier,
                builder: (context, selectedDate, child) {
                  return ValueListenableBuilder<List<Medicine>>(
                    valueListenable: globalMedicinesNotifier,
                    builder: (context, allMedicines, child) {
                      // 👇 FILTER BARU: Cek Consumed & Cek Jadwal (Interval) 👇
                      final medsToTake = allMedicines
                          .where(
                            (m) =>
                                !m.isConsumedOn(selectedDate) &&
                                m.isScheduledForDate(
                                  selectedDate,
                                ), // Cek Intervalnya di sini!
                          )
                          .toList();

                      final medsTaken = allMedicines
                          .where(
                            (m) =>
                                m.isConsumedOn(selectedDate) &&
                                m.isScheduledForDate(
                                  selectedDate,
                                ), // Cek Intervalnya di sini!
                          )
                          .toList();
                      // 👆 SELESAI 👇

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            MedsListSection(
                              title: 'Meds to Take',
                              medicines: medsToTake,
                              isCompletedSection: false,
                            ),
                            const SizedBox(height: 16),
                            MedsListSection(
                              title: 'Meds Taken',
                              medicines: medsTaken,
                              isCompletedSection: true,
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
      ),
    );
  }
}
