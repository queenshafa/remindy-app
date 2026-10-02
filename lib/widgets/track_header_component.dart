import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/circle_icon_button.dart';
import 'package:remindy_app/widgets/settings_bottom_sheet.dart';

// --- JUDUL HALAMAN ---
class HistoryTitle extends StatelessWidget {
  const HistoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Medicine\nRecord.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -1,
            color: AppTheme.textPrimary,
          ),
        ),
        Row(
          children: [
            CircleIconButton(
              icon: Icons.settings_outlined,
              onTap: () {
                SettingsBottomSheet.show(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

// --- SEARCH BAR (Full bersih tanpa kotak ketimpa & tanpa tombol filter merah) ---
class HistorySearchBar extends StatelessWidget {
  final ValueChanged<String> onSearch;
  const HistorySearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search by Dates, Months, Year...',
                border: InputBorder.none,
                filled: false, // Mencegah warna tema bocor
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- FILTER CHIPS ---
class HistoryFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const HistoryFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All Time', 'Last week', 'Last month', 'By year'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : const Color(0xFF7E7D7A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
