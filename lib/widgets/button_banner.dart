import 'package:flutter/material.dart';
import 'package:remindy_app/theme/app_theme.dart';

class ButtonBanner extends StatelessWidget {
  const ButtonBanner({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        24,
      ), // Radius kartu lebih melengkung sesuai desain
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          24,
        ), // Agar efek ripple ikutan melengkung
        child: Container(
          width: 190,
          padding: const EdgeInsets.all(20), // Padding dalam kartu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Lingkaran Merah
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle, // Buat lingkaran sempurna
                ),
                child: Icon(icon, size: 26, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Title (Adherence Rate / Day 45/180)
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),

              // Description (90% Adherence / 135 days left)
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
