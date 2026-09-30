import 'package:flutter/material.dart';
import '../models/medicine.dart';

class DummyUser {
  static const String email = 'nari@remindy.com';
  static const String password = 'remindy123';
  static const String name = 'Nari';
}

final ValueNotifier<String> globalUserNameNotifier = ValueNotifier('Nari');
final ValueNotifier<String> globalFamilyNumberNotifier = ValueNotifier('+62');

// 👉 GLOBAL STATE: Untuk mendeteksi kalender sedang ada di hari apa
final ValueNotifier<DateTime> globalSelectedDateNotifier = ValueNotifier(
  DateTime.now(),
);

final ValueNotifier<List<Medicine>> globalMedicinesNotifier = ValueNotifier([
  Medicine(
    id: 'm1',
    title: 'Rifampisin',
    latinName: 'Rifampicinum',
    type: 'Capsule',
    quantity: '1 capsule',
    totalDosage: '150 mg',
    remain: 20,
    time: DateTime(2026, 9, 28, 9, 0),
    isMeal: true,
    category: 'Morning',
    imageUrl:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=1000&auto=format&fit=crop',
  ),
  Medicine(
    id: 'm2',
    title: 'Paracetamol',
    latinName: 'Acetaminophen',
    type: 'Tablet',
    quantity: '1 tablet',
    totalDosage: '500 mg',
    remain: 12,
    time: DateTime(2026, 9, 28, 13, 0),
    isMeal: false,
    category: 'Afternoon',
    imageUrl:
        'https://images.unsplash.com/photo-1628771065518-0d82f1938462?q=80&w=1000&auto=format&fit=crop',
  ),
]);

void addMedicine(Medicine newMedicine) {
  final updatedList = List<Medicine>.from(globalMedicinesNotifier.value)
    ..add(newMedicine);
  globalMedicinesNotifier.value = updatedList;
}

// 👉 MENCATAT TANGGAL SAAT OBAT DIMINUM
void markMedicineAsConsumed(String id, DateTime date) {
  String dateStr =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  final currentList = globalMedicinesNotifier.value;
  globalMedicinesNotifier.value = currentList.map((med) {
    if (med.id == id) {
      final newConsumedDates = List<String>.from(med.consumedDates);
      if (!newConsumedDates.contains(dateStr)) {
        newConsumedDates.add(dateStr); // Simpan tanggal minumnya
      }
      return med.copyWith(consumedDates: newConsumedDates);
    }
    return med;
  }).toList();
}
