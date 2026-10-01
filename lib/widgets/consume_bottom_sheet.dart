import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/theme/app_theme.dart';
// 👉 JANGAN LUPA IMPORT SERVICE-NYA:
import 'package:remindy_app/services/whatsapp_service.dart';

class ConsumeBottomSheet extends StatelessWidget {
  final String medicineId;

  const ConsumeBottomSheet({super.key, required this.medicineId});

  static void show(BuildContext context, String medicineId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ConsumeBottomSheet(medicineId: medicineId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Have you taken\nyour medicine?',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 32),

          // --- TOMBOL DONE ---
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // 1. Tandai obat sebagai diminum di UI
                markMedicineAsConsumed(
                  medicineId,
                  globalSelectedDateNotifier.value,
                );

                // 2. Ambil detail obat untuk nama pesan WA
                final currentMedicines = globalMedicinesNotifier.value;
                final takenMed = currentMedicines.firstWhere(
                  (m) => m.id == medicineId,
                );

                // 3. Kirim WA ke nomor keluarga (contoh: '6281234567890')
                WhatsAppService.sendNotification(
                  phoneNumber: globalFamilyNumberNotifier
                      .value, // Pastikan ini terisi nomor valid
                  medicineName: takenMed.title,
                  status: 'SUDAH DIMINUM ✅',
                );

                Navigator.pop(context);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Text(
                'Already Taken (Done)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          // --- TOMBOL NOT YET ---
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Not Yet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
