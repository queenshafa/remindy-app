import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItemData(icon: Icons.home_outlined, label: 'Home'),
      _NavItemData(icon: Icons.history_rounded, label: 'History'),
      _NavItemData(icon: Icons.medication_liquid_outlined, label: 'Meds'),
      _NavItemData(icon: Icons.add, label: 'Add'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Menciutkan lebar container agar pas seukuran isi ikon saja
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;
          final item = items[index];

          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: Padding(
              // Space between buttons
              padding: EdgeInsets.only(
                right: index == items.length - 1 ? 0 : 14,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 20 : 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary
                      : const Color(0xFF7E7D7A),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, color: Colors.white, size: 28),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  _NavItemData({required this.icon, required this.label});
}
