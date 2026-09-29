import 'package:flutter/material.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/meds_detail_components.dart';

class MedsDetailScreen extends StatelessWidget {
  // Kita bisa menggunakan dummyBanners[0].imageUrl dari data lama kamu
  final String imageUrl;

  const MedsDetailScreen({
    super.key,
    this.imageUrl =
        'https://img.pikbest.com/origin/09/17/05/62EpIkbEsTQ8w.jpg!bw800', // Default fallback image
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 1. Header (Back & Edit)
              const DetailHeader(),
              const SizedBox(height: 24),

              // 2. Banner Foto Obat
              DetailImageBanner(imageUrl: imageUrl),
              const SizedBox(height: 24),

              // 3. Judul Utama
              const DetailTitleSection(
                title: 'Pyrazinamide',
                subtitle: 'Pyrazinamidum',
                type: 'Tablet',
              ),
              const SizedBox(height: 16),

              // 4. Chip Sisa Obat
              const DetailRemainChip(remainText: '15 Tablet Remain'),
              const SizedBox(height: 32),

              // 5. Grid Info Kotak-Kotak Putih
              const DetailInfoGrid(),

              const SizedBox(
                height: 120,
              ), // Memberi ruang lega untuk Floating Navbar
            ],
          ),
        ),
      ),
    );
  }
}
