import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/screen/main_screen.dart';
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

  // Variabel untuk RevenueCat
  Offerings? _offerings;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(() {
      if (_sheetController.size < 0.1 && _isProActive) {
        setState(() => _isProActive = false);
      }
    });

    // Tarik data paket dari RevenueCat saat layar dibuka
    _fetchOfferings();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  // --- LOGIKA REVENUE CAT ---

  Future<void> _fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && mounted) {
        setState(() {
          _offerings = offerings;
        });
      }
    } on PlatformException catch (e) {
      debugPrint("Gagal mengambil paket: $e");
    }
  }

  Future<void> _processPurchase() async {
    setState(() => _isLoading = true);

    // Simulasi proses pembayaran hackathon (loading 2 detik)
    await Future.delayed(const Duration(seconds: 2));

    // Aktifkan status Pro secara instan untuk kebutuhan demo
    globalIsProNotifier.value = true;

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Remindy Pro! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Tutup bottom sheet
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      if (customerInfo.entitlements.all["pro"]?.isActive == true) {
        globalIsProNotifier.value = true;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subscription Restored!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No active subscription found.')),
          );
      }
    } on PlatformException catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- AKHIR LOGIKA REVENUE CAT ---

  void _toggleProState(bool isPro) {
    setState(() {
      _isProActive = isPro;
    });

    if (isPro) {
      _sheetController.animateTo(
        0.75,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
      );
    } else {
      _sheetController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  // Helper untuk mengambil harga asli atau harga fallback
  String _getPrice(Package? package, String fallbackPrice) {
    return package?.storeProduct.priceString ?? fallbackPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // ================= BACKGROUND CONTENT =================
          Column(
            children: [
              // HEADER (Kode persis sama seperti sebelumnya)
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
                    Text(
                      'Take care of your\nlong term needs.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // TOGGLE BUTTON
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

              // MAIN CONTENT
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
                            _toggleProState(true); // Arahkan ke Pro
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

          // ================= DRAGGABLE SHEET =================
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.0,
            minChildSize: 0.0,
            maxChildSize: 0.85,
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

                    // HARGA DIAMBIL LANGSUNG DARI REVENUE CAT JIKA ADA
                    SubsPricingCard(
                      title: 'Lifetime',
                      badgeText: 'Best Value',
                      duration: '/unlimited',
                      isBestValue: true,
                      price: _getPrice(_offerings?.current?.lifetime, '\$100'),
                      isSelected: _selectedPlan == 'Lifetime',
                      onTap: () => setState(() => _selectedPlan = 'Lifetime'),
                    ),
                    SubsPricingCard(
                      title: 'Yearly',
                      badgeText: '-25%',
                      duration: '/year',
                      price: _getPrice(_offerings?.current?.annual, '\$50'),
                      isSelected: _selectedPlan == 'Yearly',
                      onTap: () => setState(() => _selectedPlan = 'Yearly'),
                    ),
                    SubsPricingCard(
                      title: 'Monthly',
                      badgeText: '-25%',
                      duration: '/month',
                      price: _getPrice(_offerings?.current?.monthly, '\$4'),
                      isSelected: _selectedPlan == 'Monthly',
                      onTap: () => setState(() => _selectedPlan = 'Monthly'),
                    ),
                    const SizedBox(height: 16),

                    // TOMBOL BAYAR
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
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

                    // TOMBOL RESTORE
                    Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : _restorePurchases,
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
