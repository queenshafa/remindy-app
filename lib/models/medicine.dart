import 'package:flutter/material.dart';

class Medicine {
  final String id;
  final String title;
  final String latinName;
  final String type;
  final String quantity;
  final String totalDosage;
  final int remain;
  final DateTime time;
  final bool isMeal;
  final String category;
  final String imageUrl;
  final List<String> consumedDates;
  final String? dosisLengkap;
  final String? lamaKonsumsi;
  final String? periodeMinum;
  final String? catatan;
  final int intervalHari;

  Medicine({
    required this.id,
    required this.title,
    required this.latinName,
    required this.type,
    required this.quantity,
    required this.totalDosage,
    required this.remain,
    required this.time,
    required this.isMeal,
    required this.category,
    required this.imageUrl,
    this.consumedDates = const [],
    this.dosisLengkap,
    this.lamaKonsumsi,
    this.periodeMinum,
    this.catatan,
    this.intervalHari = 1,
  });

  bool isScheduledForDate(DateTime selectedDate) {
    DateTime startDate = DateTime(time.year, time.month, time.day);
    DateTime targetDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (targetDate.isBefore(startDate)) return false;

    int differenceInDays = targetDate.difference(startDate).inDays;
    return differenceInDays % intervalHari == 0;
  }

  bool isConsumedOn(DateTime date) {
    String dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return consumedDates.contains(dateString);
  }

  Medicine copyWith({
    DateTime? time,
    List<String>? consumedDates,
    int? remain, // <-- Pastikan ada ini
  }) {
    return Medicine(
      id: id,
      title: title,
      latinName: latinName,
      type: type,
      quantity: quantity,
      totalDosage: totalDosage,
      remain: remain ?? this.remain, // <-- Update remain
      time: time ?? this.time,
      isMeal: isMeal,
      category: category,
      imageUrl: imageUrl,
      consumedDates: consumedDates ?? this.consumedDates,
      dosisLengkap: dosisLengkap,
      lamaKonsumsi: lamaKonsumsi,
      periodeMinum: periodeMinum,
      catatan: catatan,
      intervalHari: intervalHari,
    );
  }
}
