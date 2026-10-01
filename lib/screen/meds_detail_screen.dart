import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/screen/edit_meds_screen.dart'; // Import layar edit baru
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/widgets/meds_detail_components.dart';

class MedsDetailScreen extends StatelessWidget {
  final Medicine medicine; // Menerima data awal

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
    // ValueListenableBuilder memastikan layar ini di-render ulang (refresh otomatis)
    // setiap kali ada perubahan pada globalMedicinesNotifier (setelah diedit)
    return ValueListenableBuilder<List<Medicine>>(
      valueListenable: globalMedicinesNotifier,
      builder: (context, medsList, child) {
        // Cari data obat terbaru berdasarkan ID.
        // Jika tidak ketemu (misal terhapus), fallback ke data lama.
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

                  // CUSTOM HEADER: Hanya Tombol Back (Tombol Edit atas dihilangkan)
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
                        '${currentMed.remain} ${currentMed.type} Tersisa',
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Frekuensi/Hari:',
                          currentMed.quantity,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Waktu Pengingat:',
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
                          'Dosis Obat:',
                          currentMed.dosisLengkap ?? '-',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Lama Konsumsi:',
                          currentMed.lamaKonsumsi ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Periode Minum:',
                          currentMed.periodeMinum ?? '-',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Aturan Minum:',
                          currentMed.totalDosage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    'Catatan Tambahan:',
                    (currentMed.catatan == null || currentMed.catatan!.isEmpty)
                        ? 'Tidak ada catatan'
                        : currentMed.catatan!,
                  ),

                  const SizedBox(height: 40),

                  // 👇 TOMBOL EDIT PRIMARY DI BAWAH 👇
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Arahkan ke form edit dengan mengirimkan data obat terbaru
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
                        'Edit Data Obat',
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
