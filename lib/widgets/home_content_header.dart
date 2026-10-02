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
              int maxDaysLeft = 0;
              final now = DateTime.now();
              // Normalisasi waktu ke tengah malam agar hitungan hari presisi
              final today = DateTime(now.year, now.month, now.day);

              for (var med in medicines) {
                int totalDays = 0;

                // 1. Hitung total durasi hari berdasarkan inputan
                if (med.lamaKonsumsi != null && med.lamaKonsumsi!.isNotEmpty) {
                  final parts = med.lamaKonsumsi!.split(' ');
                  if (parts.length >= 2) {
                    int val = int.tryParse(parts[0]) ?? 0;
                    String unit = parts[1].toLowerCase();

                    if (unit.contains('day') || unit.contains('hari')) {
                      totalDays = val;
                    } else if (unit.contains('week') ||
                        unit.contains('minggu')) {
                      totalDays = val * 7;
                    } else if (unit.contains('month') ||
                        unit.contains('bulan')) {
                      totalDays = val * 30;
                    } else if (unit.contains('year') ||
                        unit.contains('tahun')) {
                      totalDays = val * 365;
                    }
                  }
                }

                // 2. Hitung berapa hari yang sudah berlalu sejak startDate
                int daysPassed = 0;
                if (med.startDate != null) {
                  final start = DateTime(
                    med.startDate!.year,
                    med.startDate!.month,
                    med.startDate!.day,
                  );
                  daysPassed = today.difference(start).inDays;
                }

                // 3. Kurangi total hari dengan hari yang sudah berlalu
                int daysLeft = totalDays - daysPassed;
                if (daysLeft < 0) {
                  daysLeft = 0; // Cegah angka minus kalau sudah lewat target
                }

                // 4. Cari nilai sisa hari paling panjang di antara semua obat
                if (daysLeft > maxDaysLeft) {
                  maxDaysLeft = daysLeft;
                }
              }

              return Row(
                children: [
                  Expanded(
                    child: ButtonBanner(
                      icon: Icons.calendar_month_rounded,
                      title: 'Longest Meds',
                      description:
                          '$maxDaysLeft Days Left', // Sekarang angkanya otomatis turun!
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
