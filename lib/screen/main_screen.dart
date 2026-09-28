import 'package:flutter/material.dart';
import 'package:remindy_app/screen/home_screen.dart';
import 'package:remindy_app/widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('History Screen')),
    const Center(child: Text('Meds Screen')),
    const Center(child: Text('Settings Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack so navbar absolutely stack everything on top
      body: Stack(
        children: [
          // The bottom of the Stack
          IndexedStack(index: _currentIndex, children: _screens),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CustomBottomNavbar(
                selectedIndex: _currentIndex,
                onItemTapped: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
