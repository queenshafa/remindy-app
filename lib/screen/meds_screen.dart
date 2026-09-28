import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/meds_header.dart';
import 'package:remindy_app/widgets/meds_list_section.dart';

class MedsScreen extends StatefulWidget {
  const MedsScreen({super.key});

  @override
  State<MedsScreen> createState() => _MedsScreenState();
}

class _MedsScreenState extends State<MedsScreen> {
  // Simulasi data obat yang belum dimakan dan sudah dimakan
  final List<Medicine> medsToTake = dummyMedicines.take(2).toList();
  final List<Medicine> medsTaken = dummyMedicines.skip(2).take(1).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MedsHeader(), // <-- Header Merah dipanggil di sini

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // <-- Section: Meds to Take
                  MedsListSection(title: 'Meds to Take', medicines: medsToTake),

                  const SizedBox(height: 16),

                  // <-- Section: Meds Taken
                  MedsListSection(title: 'Meds Taken', medicines: medsTaken),

                  // Jarak aman untuk floating navbar
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
