import 'package:flutter/material.dart';
import 'package:remindy_app/screen/onboarding_screen.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/screen/main_screen.dart'; // Ganti jika halaman awalmu bukan main_screen.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Inisialisasi durasi animasi (1.5 detik)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. Animasi Fade (dari transparan 0.0 ke jelas 1.0)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // 3. Animasi Scale (dari ukuran 80% ke 100% dengan efek memantul di akhir)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // 4. Jalankan animasi
    _controller.forward();

    // 5. Pindah ke halaman utama setelah delay 3 detik (waktu splash screen tampil)
    Future.delayed(const Duration(seconds: 3), () {
      // Pastikan context masih valid sebelum berpindah layar
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ), // Arahkan ke layar beranda kamu
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Wajib dihapus agar memori tidak bocor
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background merah solid sesuai dengan gambar desainmu
      backgroundColor: AppTheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/logo_splash.png', // 👇 NAMA FILE GAMBARMU NANTI
              width: 180, // Sesuaikan ukuran gambar
              // Kalau gambar belum ada, kita kasih pesan fallback error biar app nggak crash
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Remindy+',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
