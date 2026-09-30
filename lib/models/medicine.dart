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
  });

  bool isConsumedOn(DateTime date) {
    String dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return consumedDates.contains(dateString);
  }

  // 👇 PERBAIKANNYA DI SINI: Menambahkan parameter time 👇
  Medicine copyWith({
    DateTime? time, // <-- Tambahkan ini
    List<String>? consumedDates,
  }) {
    return Medicine(
      id: id,
      title: title,
      latinName: latinName,
      type: type,
      quantity: quantity,
      totalDosage: totalDosage,
      remain: remain,
      time: time ?? this.time, // <-- Gunakan time baru jika ada
      isMeal: isMeal,
      category: category,
      imageUrl: imageUrl,
      consumedDates: consumedDates ?? this.consumedDates,
    );
  }
}
