import '../models/medicine.dart';

class DummyUser {
  static const String email = 'nari@remindy.com';
  static const String password = 'remindy123';
  static const String name = 'Nari';
}

final List<Medicine> dummyMedicines = [
  Medicine(
    id: 'm1',
    title: 'Rifampisin',
    quantity: '10mg',
    time: DateTime(2026, 9, 28, 9, 0),
    isMeal: true, // After meal
    category: 'Morning',
  ),
  Medicine(
    id: 'm2',
    title: 'Paracetamol',
    quantity: '500mg',
    time: DateTime(2026, 9, 28, 13, 0),
    isMeal: false, // Before meal
    category: 'Afternoon',
  ),
  Medicine(
    id: 'm3',
    title: 'Amoxicillin',
    quantity: '250mg',
    time: DateTime(2026, 9, 28, 18, 30),
    isMeal: true,
    category: 'Evening',
  ),
  Medicine(
    id: 'm4',
    title: 'Vitamin C',
    quantity: '1000mg',
    time: DateTime(2026, 9, 28, 21, 0),
    isMeal: true,
    category: 'Night',
  ),
];
