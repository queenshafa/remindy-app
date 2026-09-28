import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/screen/add_meds_manual_screen.dart';
import 'package:remindy_app/screen/add_meds_scan_screen.dart';

class AddMedsBottomSheet extends StatelessWidget {
  const AddMedsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddMedsBottomSheet(),
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
          // Drag Handle
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
            'Choose your option\nto input',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 32),
          // Tombol Manual Fill
          _buildOptionButton(context, 'Manual Fill', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedsManualScreen()),
            );
          }),
          const SizedBox(height: 16),
          // Tombol AI Scan
          _buildOptionButton(context, 'AI Scan', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedsScanScreen()),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
