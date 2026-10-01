import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/theme/app_theme.dart';

// 1. Header Navigation (Back & Edit)
class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.edit, color: Colors.black, size: 20),
      ),
    ],
  );
}

// 2. Banner Gambar Obat
class DetailImageBanner extends StatelessWidget {
  final String imageUrl;
  const DetailImageBanner({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
  );
}

// 3. Bagian Judul (Nama Obat & Tipe Pill)
class DetailTitleSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String type;
  const DetailTitleSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          type,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}

// 4. Chip Sisa Obat (Warna Merah dengan Lingkaran Plus)
class DetailRemainChip extends StatelessWidget {
  final String remainText;
  const DetailRemainChip({super.key, required this.remainText});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      color: AppTheme.primary,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary, width: 1),
          ),
          child: const Icon(Icons.add, color: AppTheme.primary, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          remainText,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

// 5. Grid Kotak Info Putih (Dosage, Time, Total, Instruction)
class DetailInfoGrid extends StatelessWidget {
  final Medicine medicine;
  const DetailInfoGrid({super.key, required this.medicine});

  // Fungsi helper untuk memformat jam 10:00 -> 10.00 AM
  String _formatTime(DateTime time) {
    int h = time.hour > 12 ? time.hour - 12 : time.hour;
    if (h == 0) h = 12;
    String hr = h.toString().padLeft(2, '0');
    String min = time.minute.toString().padLeft(2, '0');
    String ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hr.$min $ampm';
  }

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 1.4,
    children: [
      _InfoCard(label: 'Dosage/day:', value: medicine.quantity),
      _InfoCard(label: 'Time to take:', value: _formatTime(medicine.time)),
      _InfoCard(label: 'Total dosage:', value: medicine.totalDosage),
      _InfoCard(
        label: 'Instruction:',
        value: medicine.isMeal ? 'After meal' : 'Before meal',
      ),
    ],
  );
}

// Helper untuk Kotak Info
class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    ),
  );
}
