import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/screen/main_screen.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/button_banner.dart';
import 'package:remindy_app/widgets/circle_icon_button.dart';
import 'package:remindy_app/widgets/settings_bottom_sheet.dart';

class HomeContentHeader extends StatelessWidget {
  const HomeContentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(24, 24, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ValueListenableBuilder<String>(
                valueListenable: globalUserNameNotifier,
                builder: (context, userName, child) {
                  return Text(
                    'G\'day, $userName!',
                    style: const TextStyle(
                      fontSize: 36,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              const Spacer(),
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.settings_outlined,
                    onTap: () {
                      SettingsBottomSheet.show(context);
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
          Text(
            'Are You Taking Your Meds Regularly?',
            style: AppTheme.display(),
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<List<Medicine>>(
            valueListenable: globalMedicinesNotifier,
            builder: (context, medicines, child) {
              // 1. LOGIKA MENCARI MAKSIMUM HARI KONSUMSI
              int maxDays = 0;
              for (var med in medicines) {
                int currentMedDays = 0;

                if (med.lamaKonsumsi != null && med.lamaKonsumsi!.isNotEmpty) {
                  final parts = med.lamaKonsumsi!.split(' ');
                  if (parts.length >= 2) {
                    int val = int.tryParse(parts[0]) ?? 0;
                    String unit = parts[1].toLowerCase();

                    // Mengecek satuan dalam bahasa Inggris (dan fallback bahasa Indonesia)
                    if (unit.contains('day') || unit.contains('hari')) {
                      currentMedDays = val;
                    } else if (unit.contains('week') ||
                        unit.contains('minggu')) {
                      currentMedDays = val * 7;
                    } else if (unit.contains('month') ||
                        unit.contains('bulan')) {
                      currentMedDays = val * 30; // Estimasi 30 hari/bulan
                    } else if (unit.contains('year') ||
                        unit.contains('tahun')) {
                      currentMedDays = val * 365;
                    }
                  }
                }

                // Jika hari obat ini lebih besar dari maxDays sebelumnya, timpa nilainya (tidak ditambahkan)
                if (currentMedDays > maxDays) {
                  maxDays = currentMedDays;
                }
              }

              // 2. TAMPILAN BANNER
              return Row(
                children: [
                  // KIRI: DAYS LEFT (Durasi Maksimal)
                  Expanded(
                    child: ButtonBanner(
                      icon: Icons.calendar_month_rounded,
                      title: 'Longest Meds',
                      description: '$maxDays Days Left',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 16),

                  // KANAN: VISIT TRACK (Riwayat Obat)
                  Expanded(
                    child: ButtonBanner(
                      icon: Icons.history_rounded,
                      title: 'Track History',
                      description: 'Visit Track',
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScreen(initialIndex: 1),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
