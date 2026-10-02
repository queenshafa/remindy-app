import 'package:flutter/material.dart';
import 'package:remindy_app/screen/home_screen.dart';
import 'package:remindy_app/screen/meds_screen.dart';
import 'package:remindy_app/screen/track_screen.dart';
import 'package:remindy_app/screen/add_meds_manual_screen.dart'; // 👇 IMPORT LAYAR MANUAL FILL 👇
import 'package:remindy_app/widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const TrackScreen(),
    const MedsScreen(),
    const SizedBox(),
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
                  if (index == 3) {
                    // 👇 UBAH LOGIKA DI SINI: LANGSUNG PUSH KE MANUAL SCREEN 👇
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddMedsManualScreen(),
                      ),
                    );
                  } else {
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
