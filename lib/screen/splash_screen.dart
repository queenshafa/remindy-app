import 'package:flutter/material.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/screen/main_screen.dart';
import 'package:remindy_app/screen/onboarding_screen.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // 5. Panggil fungsi pengecekan memori (Setup / Onboarding)
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Jalankan inisialisasi auto-save data
    await initAppData();

    // Kasih jeda waktu 2 detik biar logo Splash Screen-nya kelihatan
    await Future.delayed(const Duration(seconds: 2));

    // Cek apakah user sudah pernah menyelesaikan setup
    final prefs = await SharedPreferences.getInstance();
    bool isSetupDone = prefs.getBool('isSetupDone') ?? false;

    if (!mounted) return;

    if (isSetupDone) {
      // Kalau sudah pernah setup, langsung lompat ke MainScreen!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Kalau belum (baru pertama kali install), pergi ke Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  } // <-- Ini kurung kurawal yang tadi kelupaan

  @override
  void dispose() {
    _controller.dispose(); // Wajib dihapus agar memori tidak bocor
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/images/logo_splash.png',
                width: 180,
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
      ),
    );
  }
}
