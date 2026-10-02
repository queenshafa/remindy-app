import 'dart:convert';
import 'package:http/http.dart' as http;

class WhatsAppService {
  // REPLACE THIS IP WITH YOUR MAC'S LOCAL IP (e.g., 192.168.1.5)
  // DO NOT use localhost if you are testing on a real phone (via data cable)
  static const String baseUrl = 'http://127.0.0.1:3000/send/text';

  static Future<void> sendNotification({
    required String phoneNumber,
    required String medicineName,
    required String status,
  }) async {
    print('🚀 Flutter attempting to send to: $baseUrl');
    print('📦 Data: Number=$phoneNumber, Medicine=$medicineName');

    try {
      // 1. Bersihkan karakter selain angka dan tanda '+'
      String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // 2. Logika kode negara fleksibel
      if (cleanPhone.startsWith('+')) {
        // Jika pakai '+' (misal +1, +61), hapus tanda '+' nya saja
        cleanPhone = cleanPhone.substring(1);
      } else if (cleanPhone.startsWith('0')) {
        // Jika diawali '0', asumsikan nomor lokal Indonesia (+62)
        cleanPhone = '62${cleanPhone.substring(1)}';
      }
      // Jika langsung angka (misal 1415, 614, 628), biarkan saja.

      String message =
          "Hello! Please be informed that your medicine *$medicineName* is currently marked as: *$status*.\n\n- Automated notification from Remindy.";

      print('🔄 Sending request to Node.js server...');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"msisdn": cleanPhone, "message": message}),
      );

      print('📥 Response from Server: Status Code = ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ SUCCESS! WhatsApp notification sent to $cleanPhone');
      } else {
        print('❌ FAILED FROM SERVER. Body: ${response.body}');
      }
    } catch (e) {
      print('⚠️ NETWORK ERROR: $e');
      print(
        'Make sure the Server IP address (baseUrl) is correct and the server is running.',
      );
    }
  }
}
