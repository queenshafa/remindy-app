import 'package:flutter/material.dart';
import 'package:remindy_app/screen/home_screen.dart';
import 'package:remindy_app/screen/meds_detail_screen.dart';
import 'package:remindy_app/screen/meds_screen.dart';
import 'package:remindy_app/screen/track_screen.dart';
import 'package:remindy_app/widgets/add_meds_bottom_sheet.dart';
import 'package:remindy_app/widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 1. Perbaiki list screens, ganti index ke-3 dengan widget kosong (placeholder) saja
  final List<Widget> _screens = [
    const HomeScreen(),
    const TrackScreen(),
    const MedsScreen(),
    const SizedBox(), // Placeholder untuk tab '+' (tidak akan ditampilkan penuh)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CustomBottomNavbar(
                selectedIndex: _currentIndex,
                onItemTapped: (index) {
                  // 2. Taruh logikanya di sini!
                  if (index == 3) {
                    // Jika tombol '+' (index ke-3) ditekan, panggil bottom sheet
                    // Kita TIDAK menggunakan setState agar layar di belakangnya tidak ikut berubah
                    AddMedsBottomSheet.show(context);
                  } else {
                    // Jika tab lain ditekan, pindah halaman seperti biasa
                    setState(() {
                      _currentIndex = index;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
