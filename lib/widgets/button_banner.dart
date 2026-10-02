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
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          // Ukuran diset fleksibel agar tidak overflow saat dibagi 2 di layar
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 26, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14, // Dikecilkan sedikit agar muat dengan rapi
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
