import 'package:flutter/material.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/widgets/meds_detail_components.dart';

class MedsDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedsDetailScreen({super.key, required this.medicine});

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

              const DetailHeader(),
              const SizedBox(height: 24),

              // 1. Banner beda-beda dari URL obat
              DetailImageBanner(imageUrl: medicine.imageUrl),
              const SizedBox(height: 24),

              // 2. Info Judul (Nama, Latin, dan Tipe)
              DetailTitleSection(
                title: medicine.title,
                subtitle: medicine.latinName,
                type: medicine.type,
              ),
              const SizedBox(height: 16),

              // 3. Info Sisa obat
              DetailRemainChip(
                remainText: '${medicine.remain} ${medicine.type} Remain',
              ),
              const SizedBox(height: 32),

              // 4. Grid Kotak Informasi Dinamis
              DetailInfoGrid(medicine: medicine),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
