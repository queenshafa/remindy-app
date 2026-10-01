import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/subs_components.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  bool _isProActive = false;
  String _selectedPlan = 'Lifetime';
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    // Listener ini berguna kalau user manual nge-drag sheet ke bawah sampai hilang,
    // toggle-nya otomatis pindah ke "7-day free trial"
    _sheetController.addListener(() {
      if (_sheetController.size < 0.1 && _isProActive) {
        setState(() {
          _isProActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengatur Toggle dan animasi Bottom Sheet
  void _toggleProState(bool isPro) {
    setState(() {
      _isProActive = isPro;
    });

    if (isPro) {
      // Buka Bottom Sheet sampai 75% layar
      _sheetController.animateTo(
        0.75,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
      );
    } else {
      // Sembunyikan Bottom Sheet
      _sheetController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // ==========================================
          // LAYER BAWAH (BACKGROUND CONTENT)
          // ==========================================
          Column(
            children: [
              // 1. RED HEADER WIDGET (Ditulis langsung agar mudah akses state)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 24,
                  right: 24,
                  bottom: 30,
                ),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tombol Close (X)
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppTheme.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Judul Header
                    Text(
                      'Take care of your\nlong term needs.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // TOGGLE BUTTON (Pill Switch)
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleProState(false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !_isProActive
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '7-day free trial',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: !_isProActive
                                        ? AppTheme.primary
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleProState(true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isProActive
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Remindy Pro',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _isProActive
                                        ? AppTheme.primary
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. MAIN CONTENT (FEATURES & TRIAL INFO)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      const SubsFeaturesList(),
                      const SizedBox(height: 32),
                      // Sembunyikan Info Trial jika Pro sedang aktif
                      AnimatedOpacity(
                        opacity: _isProActive ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: _isProActive
                            ? const SizedBox()
                            : const SubsTrialInfo(),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. START TRIAL BUTTON (Hanya muncul jika tidak di tab Pro)
              if (!_isProActive)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Aksi Mulai Trial
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'Start my 7-day trial',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Privacy Policy | Terms of service',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // ==========================================
          // LAYER ATAS: DRAGGABLE BOTTOM SHEET (PRICING)
          // ==========================================
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.0, // Mulai dalam keadaan tersembunyi
            minChildSize: 0.0,
            maxChildSize: 0.85, // Maksimal setinggi 85% layar
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  children: [
                    // DRAG HANDLE (Pill Abu-abu Kecil)
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // SHEET TITLE
                    Text(
                      'Activate your Remindy Pro',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unlimited access to all features to support your long-term journey and healing.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // PRICING OPTIONS
                    SubsPricingCard(
                      title: 'Lifetime',
                      badgeText: 'Best Value',
                      price: '\$100',
                      duration: '/unlimited',
                      isBestValue: true,
                      isSelected: _selectedPlan == 'Lifetime',
                      onTap: () => setState(() => _selectedPlan = 'Lifetime'),
                    ),
                    SubsPricingCard(
                      title: 'Yearly',
                      badgeText: '-25%',
                      price: '\$50',
                      duration: '/year',
                      isSelected: _selectedPlan == 'Yearly',
                      onTap: () => setState(() => _selectedPlan = 'Yearly'),
                    ),
                    SubsPricingCard(
                      title: 'Monthly',
                      badgeText: '-25%',
                      price: '\$4',
                      duration: '/month',
                      isSelected: _selectedPlan == 'Monthly',
                      onTap: () => setState(() => _selectedPlan = 'Monthly'),
                    ),
                    const SizedBox(height: 16),

                    // SUBSCRIBE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi Pembayaran
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Subscribe',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // LEGAL TEXT
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Restore Subscription',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Privacy Policy | Terms of service',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Subscription automatically renews unless canceled at least 24 hours before the end of the current period. Manage or cancel anytime in your account settings.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
