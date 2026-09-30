import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/screen/meds_detail_screen.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/consume_bottom_sheet.dart';
import 'package:remindy_app/widgets/medicine_card.dart';

class MedsListSection extends StatelessWidget {
  final String title;
  final List<Medicine> medicines;
  final bool isCompletedSection; // <-- Penanda apakah ini daftar Meds Taken

  const MedsListSection({
    super.key,
    required this.title,
    required this.medicines,
    this.isCompletedSection = false, // Default: false (ada tombolnya)
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        ...medicines.map(
          (med) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: MedicineCard(
              title: med.title,
              quantity: med.quantity,
              time: med.time,
              isMeal: med.isMeal,
              category: med.category,

              // 👉 HILANGKAN TOMBOL JIKA BERADA DI MEDS TAKEN
              onConsume: isCompletedSection
                  ? null
                  : () {
                      ConsumeBottomSheet.show(context, med.id);
                    },

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedsDetailScreen(medicine: med),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
