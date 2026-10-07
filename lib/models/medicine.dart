class Medicine {
  final String id;
  final String title;
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
  final DateTime? startDate;
  final String? periodeMinum;
  final String? catatan;
  final int intervalHari;

  Medicine({
    required this.id,
    required this.title,
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
    this.startDate,
    this.periodeMinum,
    this.catatan,
    this.intervalHari = 1,
  });

  bool isScheduledForDate(DateTime selectedDate) {
    DateTime start = DateTime(time.year, time.month, time.day);
    DateTime targetDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (targetDate.isBefore(start)) return false;

    int differenceInDays = targetDate.difference(start).inDays;
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
    int? remain,
    DateTime? startDate,
  }) {
    return Medicine(
      id: id,
      title: title,
      type: type,
      quantity: quantity,
      totalDosage: totalDosage,
      remain: remain ?? this.remain,
      time: time ?? this.time,
      isMeal: isMeal,
      category: category,
      imageUrl: imageUrl,
      consumedDates: consumedDates ?? this.consumedDates,
      startDate: startDate ?? this.startDate,
      dosisLengkap: dosisLengkap,
      lamaKonsumsi: lamaKonsumsi,
      periodeMinum: periodeMinum,
      catatan: catatan,
      intervalHari: intervalHari,
    );
  }

  // Mengubah objek Medicine menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'quantity': quantity,
      'totalDosage': totalDosage,
      'remain': remain,
      'time': time.toIso8601String(),
      'isMeal': isMeal,
      'category': category,
      'imageUrl': imageUrl,
      'consumedDates': consumedDates,
      'dosisLengkap': dosisLengkap,
      'lamaKonsumsi': lamaKonsumsi,
      'startDate': startDate?.toIso8601String(),
      'periodeMinum': periodeMinum,
      'catatan': catatan,
      'intervalHari': intervalHari,
    };
  }

  // Membaca format JSON menjadi objek Medicine
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      quantity: json['quantity'],
      totalDosage: json['totalDosage'],
      remain: json['remain'],
      time: DateTime.parse(json['time']),
      isMeal: json['isMeal'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      consumedDates: List<String>.from(json['consumedDates'] ?? []),
      dosisLengkap: json['dosisLengkap'],
      lamaKonsumsi: json['lamaKonsumsi'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      periodeMinum: json['periodeMinum'],
      catatan: json['catatan'],
      intervalHari: json['intervalHari'] ?? 1,
    );
  }
} // <-- Kurung kurawal tutup dipindah ke paling bawah sini
