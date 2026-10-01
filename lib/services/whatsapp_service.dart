import 'dart:convert';
import 'package:http/http.dart' as http;

class WhatsAppService {
  // GANTI IP INI DENGAN IP LOKAL MAC KAMU (misal: 192.168.1.5)
  // JANGAN gunakan localhost kalau kamu ngetest pakai HP beneran (kabel data)
  static const String baseUrl =
      'http://127.0.0.1:3000/send/text'; // <-- Coba ubah ke 127.0.0.1 dulu

  static Future<void> sendNotification({
    required String phoneNumber,
    required String medicineName,
    required String status,
  }) async {
    print('🚀 Flutter mencoba kirim ke: $baseUrl');
    print('📦 Data: Nomor=$phoneNumber, Obat=$medicineName');

    try {
      String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

      // Validasi nomor Indonesia (pastikan depannya 62, bukan 0 atau 620)
      if (cleanPhone.startsWith('0')) {
        cleanPhone = '62${cleanPhone.substring(1)}';
      } else if (!cleanPhone.startsWith('62')) {
        cleanPhone = '62$cleanPhone';
      }

      String message =
          "Halo! Menginformasikan bahwa obat *$medicineName* saat ini berstatus: *$status*.\n\n- Notifikasi otomatis dari Remindy.";

      print('🔄 Mengirim request ke server Node.js...');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"msisdn": cleanPhone, "message": message}),
      );

      print('📥 Response dari Server: Status Code = ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ BERHASIL! Notifikasi WhatsApp terkirim ke $cleanPhone');
      } else {
        print('❌ GAGAL DARI SERVER. Body: ${response.body}');
      }
    } catch (e) {
      print('⚠️ ERROR JARINGAN: $e');
      print('Pastikan alamat IP Server (baseUrl) benar dan server nyala.');
    }
  }
}
