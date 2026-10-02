import 'package:flutter/material.dart';
import '../models/medicine.dart';

class DummyUser {
  static const String email = 'nari@remindy.com';
  static const String password = 'remindy123';
  static const String name = 'Nari';
}

final ValueNotifier<String> globalUserNameNotifier = ValueNotifier('Nari');
final ValueNotifier<String> globalFamilyNumberNotifier = ValueNotifier(
  '+6285210719896',
);
final ValueNotifier<bool> globalWaNotifNotifier = ValueNotifier(true);
final ValueNotifier<bool> globalIsProNotifier = ValueNotifier<bool>(false);

// 👉 GLOBAL STATE: Untuk mendeteksi kalender sedang ada di hari apa
final ValueNotifier<DateTime> globalSelectedDateNotifier = ValueNotifier(
  DateTime.now(),
);

// 👉 DIKOSONGKAN AGAR TIDAK ADA OBAT BAWAAN (DUMMY)
final ValueNotifier<List<Medicine>> globalMedicinesNotifier = ValueNotifier([]);

void addMedicine(Medicine newMedicine) {
  final updatedList = List<Medicine>.from(globalMedicinesNotifier.value)
    ..add(newMedicine);
  globalMedicinesNotifier.value = updatedList;
}

// 👉 MENCATAT TANGGAL SAAT OBAT DIMINUM DAN MENGURANGI STOK
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

      // Ambil angka dosis dari string quantity (misal: "2 Tablet" -> ambil angka "2")
      int doseAmount = 1;
      try {
        final parts = med.quantity.split(' ');
        if (parts.isNotEmpty) {
          doseAmount = int.tryParse(parts[0]) ?? 1;
        }
      } catch (_) {
        doseAmount = 1;
      }

      // Kurangi stok, pastikan tidak kurang dari 0 (tidak minus)
      int updatedRemain = med.remain - doseAmount;
      if (updatedRemain < 0) {
        updatedRemain = 0;
      }

      return med.copyWith(
        consumedDates: newConsumedDates,
        remain: updatedRemain, // 👉 INI YANG KEMARIN KETINGGALAN!
      );
    }
    return med;
  }).toList();
}
