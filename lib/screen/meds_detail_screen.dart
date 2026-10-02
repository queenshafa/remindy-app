import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/screen/edit_meds_screen.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/widgets/meds_detail_components.dart';

class MedsDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedsDetailScreen({super.key, required this.medicine});

  String _formatTime(DateTime time) {
    int h = time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    if (h > 12) h -= 12;
    if (h == 0) h = 12;
    final hStr = h.toString().padLeft(2, '0');
    return '$hStr.$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Medicine>>(
      valueListenable: globalMedicinesNotifier,
      builder: (context, medsList, child) {
        final currentMed = medsList.firstWhere(
          (m) => m.id == medicine.id,
          orElse: () => medicine,
        );

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // CUSTOM HEADER: Tombol Kembali
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  DetailTitleSection(
                    title: currentMed.title,
                    subtitle: '',
                    type: currentMed.type,
                  ),
                  const SizedBox(height: 16),

                  DetailRemainChip(
                    remainText:
                        '${currentMed.remain} ${currentMed.type} remaining',
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Dosage / Unit:',
                          currentMed.dosisLengkap ?? '-',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Time to Take:',
                          _formatTime(currentMed.time),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Duration:',
                          currentMed.lamaKonsumsi ?? '-',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Frequency / Interval:',
                          currentMed.periodeMinum ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Instruction:',
                          currentMed.totalDosage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    'Additional Notes:',
                    (currentMed.catatan == null || currentMed.catatan!.isEmpty)
                        ? 'No notes added'
                        : currentMed.catatan!,
                  ),

                  const SizedBox(height: 40),

                  // TOMBOL EDIT DI BAWAH
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditMedsScreen(medicine: currentMed),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Edit Medicine Data',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
