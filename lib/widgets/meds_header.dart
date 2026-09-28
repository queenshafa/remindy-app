import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';

class MedsHeader extends StatelessWidget {
  const MedsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Taking Meds,\nNari?',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCalendarDay('Mon', '14', false),
              _buildCalendarDay('Tue', '15', false),
              _buildCalendarDay('Wed', '16', false),
              _buildCalendarDay('Thu', '17', false),
              _buildCalendarDay('Fri', '18', true), // Tanggal aktif
              _buildCalendarDay('Sat', '19', false),
              _buildCalendarDay('Sun', '20', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(String day, String date, bool isActive) {
    return Column(
      children: [
        Text(
          day,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF7E7D7A) : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              date,
              style: GoogleFonts.plusJakartaSans(
                color: isActive ? Colors.white : AppTheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
