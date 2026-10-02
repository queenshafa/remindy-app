import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/screen/meds_detail_screen.dart';
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

    // Tentukan BATAS AWAL dan BATAS AKHIR (Hari ini)
    DateTime startDate;
    DateTime endDate = now; // Secara default, batas akhirnya adalah hari ini

    if (_selectedFilter == 'Last week') {
      // Menampilkan jadwal dari 7 hari yang lalu sampai HARI INI
      startDate = now.subtract(const Duration(days: 7));
    } else if (_selectedFilter == 'Last month') {
      // 🔴 PERBAIKAN: Menampilkan HANYA bulan kemarin (Full 1 bulan) 🔴
      int lastMonth = now.month - 1;
      int yearOfLastMonth = now.year;

      if (lastMonth == 0) {
        // Jika sekarang Januari, maka bulan lalu adalah Desember tahun sebelumnya
        lastMonth = 12;
        yearOfLastMonth--;
      }

      // Mulai dari tanggal 1 bulan lalu
      startDate = DateTime(yearOfLastMonth, lastMonth, 1);

      // Berakhir di hari terakhir bulan lalu (yaitu tanggal 0 dari bulan sekarang)
      endDate = DateTime(now.year, now.month, 0);
    } else if (_selectedFilter == 'By year') {
      // Menampilkan HANYA tahun ini (dari 1 Januari sampai hari ini)
      startDate = DateTime(now.year, 1, 1);
    } else {
      // All Time (Mundur 3 tahun dari hari ini)
      startDate = now.subtract(const Duration(days: 1095));
    }

    // Hitung total hari antara startDate dan endDate
    int daysToGenerate =
        endDate.difference(startDate).inDays +
        1; // +1 biar hari terakhir ikut kehitung

    // Kita generate jadwal dari endDate (i=0) mundur sampai startDate
    for (int i = 0; i < daysToGenerate; i++) {
      DateTime targetDate = endDate.subtract(Duration(days: i));

      for (var med in allData) {
        if (!med.isScheduledForDate(targetDate)) {
          continue;
        }

        DateTime historicalTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          med.time.hour,
          med.time.minute,
        );

        Medicine virtualMed = med.copyWith(time: historicalTime);

        final queryLower = _searchQuery.toLowerCase();
        final matchesSearch =
            virtualMed.title.toLowerCase().contains(queryLower) ||
            virtualMed.time.year.toString().contains(queryLower);

        if (matchesSearch) {
          historyList.add(virtualMed);
        }
      }
    }

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
                        showDateHeader = true;
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
                      final isDone = med.isConsumedOn(med.time);
                      final isMiss = !isDone && now.isAfter(med.time);

                      String? currentHistoryStatus;
                      if (isDone) {
                        currentHistoryStatus = 'done';
                      } else if (isMiss) {
                        currentHistoryStatus = 'miss';
                      }

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
                              instruction: med
                                  .totalDosage, // <-- Menggunakan teks instruksi asli
                              category: med.category,
                              historyStatus: currentHistoryStatus,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MedsDetailScreen(medicine: med),
                                  ),
                                );
                              },
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
