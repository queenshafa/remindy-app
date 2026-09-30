import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/medicine_card.dart';
import 'package:remindy_app/widgets/track_header_component.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<TrackScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All Time';

  // --- LOGIKA BACKEND GENERATE HISTORY ---
  List<Medicine> _getFilteredData(List<Medicine> allData) {
    DateTime now = DateTime.now();
    List<Medicine> historyList = [];

    // Tentukan seberapa jauh ke belakang kita membuat riwayat
    int daysToGenerate = 30; // Default All Time: 30 hari ke belakang
    if (_selectedFilter == 'Last week') daysToGenerate = 7;
    if (_selectedFilter == 'Last month') daysToGenerate = 30;
    if (_selectedFilter == 'By year') daysToGenerate = 365;

    // Kita generate jadwal dari HARI INI (i=0) mundur sampai (daysToGenerate) hari
    for (int i = 0; i < daysToGenerate; i++) {
      DateTime targetDate = now.subtract(Duration(days: i));

      for (var med in allData) {
        // Buat instance obat virtual khusus untuk tanggal target ini
        DateTime historicalTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          med.time.hour,
          med.time.minute,
        );

        // Kloning data obatnya dengan tanggal riwayat
        Medicine virtualMed = med.copyWith(time: historicalTime);

        // 1. Logika Search Teks (Cari Nama / Tahun)
        final queryLower = _searchQuery.toLowerCase();
        final matchesSearch =
            virtualMed.title.toLowerCase().contains(queryLower) ||
            virtualMed.time.year.toString().contains(queryLower);

        // Jika lolos search, masukkan ke daftar history
        if (matchesSearch) {
          historyList.add(virtualMed);
        }
      }
    }

    // Urutkan dari yang terbaru (tanggal & jam) ke yang paling lama
    historyList.sort((a, b) => b.time.compareTo(a.time));

    return historyList;
  }

  // Helper untuk mengubah angka bulan jadi nama bulan
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER TETAP STATIS DI ATAS ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HistoryTitle(),
                  const SizedBox(height: 24),

                  HistorySearchBar(
                    onSearch: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: 20),

                  HistoryFilterChips(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) =>
                        setState(() => _selectedFilter = filter),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // --- LIST DATA DINAMIS ---
            Expanded(
              child: ValueListenableBuilder<List<Medicine>>(
                valueListenable: globalMedicinesNotifier,
                builder: (context, allMedicines, child) {
                  // Panggil fungsi pembuat riwayat mundur
                  final filteredMeds = _getFilteredData(allMedicines);
                  final now = DateTime.now();

                  if (filteredMeds.isEmpty) {
                    return Center(
                      child: Text(
                        'No record found.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    itemCount: filteredMeds.length,
                    itemBuilder: (context, index) {
                      final med = filteredMeds[index];

                      // 1. Cek apakah Header Tanggal perlu dimunculkan
                      bool showDateHeader = false;
                      if (index == 0) {
                        showDateHeader =
                            true; // Item pertama pasti munculin header tanggal
                      } else {
                        final prevMed = filteredMeds[index - 1];
                        // Jika tanggal berbeda dari card sebelumnya, munculin header lagi
                        if (prevMed.time.day != med.time.day ||
                            prevMed.time.month != med.time.month ||
                            prevMed.time.year != med.time.year) {
                          showDateHeader = true;
                        }
                      }

                      String dateText =
                          "${med.time.day}, ${_getMonthName(med.time.month)}, ${med.time.year}.";

                      // 2. Tentukan status riwayat obat (Done / Miss)
                      final isDone = med.isConsumedOn(
                        med.time,
                      ); // Ngecek sesuai tanggal history card-nya
                      final isMiss = !isDone && now.isAfter(med.time);

                      String? currentHistoryStatus;
                      if (isDone) {
                        currentHistoryStatus = 'done';
                      } else if (isMiss) {
                        currentHistoryStatus = 'miss';
                      }
                      // Jika belum waktunya (masih di masa depan / jamnya belum lewat), biarkan null

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDateHeader)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                dateText,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: MedicineCard(
                              title: med.title,
                              quantity: med.quantity,
                              time: med.time,
                              isMeal: med.isMeal,
                              category: med.category,
                              historyStatus: currentHistoryStatus,
                              onTap: () {},
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
