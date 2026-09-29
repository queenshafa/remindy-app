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

  // Data konten onboarding
  final List<Map<String, String>> _onboardingData = [
    {
      "image":
          "assets/images/onboarding_1.png", // TODO: Sesuaikan dengan path gambarmu
      "title": "Lorem Ipsum\nDolor sit Amet",
    },
    {
      "image": "assets/images/onboarding_2.png",
      "title": "Lorem Ipsum\nDolor sit Amet",
    },
    {
      "image": "assets/images/onboarding_3.png",
      "title": "Lorem Ipsum\nDolor sit Amet",
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

                      debugPrint("Pindah ke MainScreen");
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
                      borderRadius: BorderRadius.circular(
                        28,
                      ), // Bentuk pil penuh
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _onboardingData.length - 1
                        ? 'Finish'
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

  // Konten per halaman (Gambar + Judul)
  Widget _buildPageContent({required String image, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Placeholder Gambar (Ganti Icon ini dengan Image.asset jika gambarnya sudah siap)
          Container(
            height: 250,
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_outlined, // Hapus Icon ini nanti
              size: 100,
              color: Colors.grey,
            ),
            /* // Pakai kode ini jika sudah ada file gambar di pubspec.yaml:
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
            */
          ),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
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
