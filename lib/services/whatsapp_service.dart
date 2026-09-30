import 'dart:convert';
import 'package:http/http.dart' as http;

class WhatsAppService {
  // 👉 Ganti URL ini dengan endpoint API GoWA milikmu!
  static const String baseUrl = 'http://URL_SERVER_GOWA_KAMU/send/text';

  static Future<void> sendNotification({
    required String phoneNumber,
    required String medicineName,
    required String status,
  }) async {
    try {
      // GoWA biasanya butuh nomor dalam format angka saja (misal: 62812xxx)
      String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

      // Susun pesan otomatisnya
      String message =
          "Halo! Menginformasikan bahwa obat *$medicineName* saat ini berstatus: *$status*.\n\n- Notifikasi otomatis dari Remindy.";

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer TOKEN_KAMU', // Buka baris ini jika GoWA kamu diproteksi token
        },
        body: jsonEncode({"msisdn": cleanPhone, "message": message}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Notifikasi WhatsApp berhasil terkirim ke $cleanPhone');
      } else {
        print(
          '❌ Gagal mengirim WA. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('⚠️ Error saat menghubungi GoWA: $e');
    }
  }
}
