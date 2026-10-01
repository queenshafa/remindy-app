import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/screen/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data konten onboarding sesuai desain
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding_1.png",
      "title": "Track Every Medicine",
      "description":
          "Keep all your TB and chronic disease medications organized in one place, no more guessing what to take.",
    },
    {
      "image": "assets/images/onboarding_2.png",
      "title": "Never Miss a Dose",
      "description":
          "Alarm-based reminders for every medication, right when you need to take it.",
    },
    {
      "image": "assets/images/onboarding_3.png",
      "title": "Heal With Support",
      "description":
          "Track your progress and let your family stay updated, so you're never on this journey alone.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Area PageView untuk Gambar dan Teks
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) => _buildPageContent(
                  image: _onboardingData[index]["image"]!,
                  title: _onboardingData[index]["title"]!,
                  description: _onboardingData[index]["description"]!,
                ),
              ),
            ),

            // 2. Indikator Titik (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => _buildDot(index: index),
              ),
            ),
            const SizedBox(height: 32),

            // 3. Tombol Bawah (Next / Finish)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _onboardingData.length - 1) {
                      // Jika di halaman terakhir (Finish), pindah ke MainScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                      );
                    } else {
                      // Jika belum terakhir (Next), geser ke halaman berikutnya
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _onboardingData.length - 1
                        ? 'Finish' // Berubah jadi Finish di halaman terakhir agar UX-nya jelas
                        : 'Next',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  // Konten per halaman (Gambar + Judul + Deskripsi)
  Widget _buildPageContent({
    required String image,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Gambar Ilustrasi
          Container(
            height:
                340, // Sesuaikan tinggi ini jika gambarmu terlalu besar/kecil
            alignment: Alignment.center,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              // Fallback error jika gambar belum kamu masukkan ke folder assets
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported_outlined,
                  size: 100,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(height: 40),

          // Judul
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // Deskripsi
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppTheme.textPrimary.withValues(
                alpha: 0.7,
              ), // Sedikit pudar agar rapi
              height: 1.5,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  // Indikator Titik
  Widget _buildDot({required int index}) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 10,
      width: isActive ? 28 : 10, // Memanjang saat aktif
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primary : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
