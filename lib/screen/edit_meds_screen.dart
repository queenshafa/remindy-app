import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/meds_form_components.dart';

class EditMedsScreen extends StatefulWidget {
  final Medicine medicine;
  const EditMedsScreen({super.key, required this.medicine});

  @override
  State<EditMedsScreen> createState() => _EditMedsScreenState();
}

class _EditMedsScreenState extends State<EditMedsScreen> {
  final _nameCtrl = TextEditingController();
  final _remainCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _dosisAngkaCtrl = TextEditingController();
  final _lamaKonsumsiAngkaCtrl = TextEditingController();
  final _hourCtrl = TextEditingController();
  final _minuteCtrl = TextEditingController();

  String _dosisSatuan = 'Tablet';
  String _lamaKonsumsiSatuan = 'hari';
  String _periodeMinum = 'Setiap Hari';
  String _frekuensi = '1';
  String _aturanMinum = 'Setelah makan';

  @override
  void initState() {
    super.initState();
    final med = widget.medicine;

    // Isi data text field bawaan
    _nameCtrl.text = med.title;
    _remainCtrl.text = med.remain.toString();
    _notesCtrl.text = med.catatan ?? '';
    _hourCtrl.text = med.time.hour.toString().padLeft(2, '0');
    _minuteCtrl.text = med.time.minute.toString().padLeft(2, '0');

    // Parse Data Dosis (contoh: "2 Kapsul" -> "2", "Kapsul")
    final dosisParts = (med.dosisLengkap ?? '1 Tablet').split(' ');
    _dosisAngkaCtrl.text = dosisParts.isNotEmpty ? dosisParts[0] : '1';
    final parsedDosisSatuan = dosisParts.length > 1 ? dosisParts[1] : 'Tablet';
    if ([
      'Supositoria',
      'Tablet',
      'Tetes',
      'Kaplet',
      'Kapsul',
      'Pil',
      'Semprotan',
    ].contains(parsedDosisSatuan)) {
      _dosisSatuan = parsedDosisSatuan;
    }

    // Parse Data Lama Konsumsi (contoh: "10 minggu" -> "10", "minggu")
    final lamaParts = (med.lamaKonsumsi ?? '1 hari').split(' ');
    _lamaKonsumsiAngkaCtrl.text = lamaParts.isNotEmpty ? lamaParts[0] : '1';
    final parsedLamaSatuan = lamaParts.length > 1 ? lamaParts[1] : 'hari';
    if (['hari', 'minggu', 'bulan', 'tahun'].contains(parsedLamaSatuan)) {
      _lamaKonsumsiSatuan = parsedLamaSatuan;
    }

    // Parse Data Periode & Frekuensi
    if (['Setiap Hari', 'Hari Pilihan'].contains(med.periodeMinum)) {
      _periodeMinum = med.periodeMinum!;
    }

    final freqParts = (med.quantity).split(' ');
    if (['1', '2', '3', '4', '5'].contains(freqParts[0])) {
      _frekuensi = freqParts[0];
    }

    if ([
      'Sebelum tidur',
      'Setelah makan',
      'Sebelum makan',
      'Setelah bangun tidur',
      'Saat Makan',
    ].contains(med.totalDosage)) {
      _aturanMinum = med.totalDosage;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _remainCtrl.dispose();
    _notesCtrl.dispose();
    _dosisAngkaCtrl.dispose();
    _lamaKonsumsiAngkaCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Custom Header Sederhana
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Edit Medicine:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),

              const MedsLabel('Nama Obat:'),
              MedsTextField(
                controller: _nameCtrl,
                hint: 'Contoh: Paracetamol...',
              ),
              const SizedBox(height: 20),

              const MedsLabel('Sisa Stok Obat (Botol/Strip):'),
              MedsTextField(controller: _remainCtrl, hint: 'Contoh: 30'),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Dosis:'),
                        MedsTextField(
                          controller: _dosisAngkaCtrl,
                          hint: 'Ex: 1',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Satuan:'),
                        _buildDropdown(
                          value: _dosisSatuan,
                          items: [
                            'Supositoria',
                            'Tablet',
                            'Tetes',
                            'Kaplet',
                            'Kapsul',
                            'Pil',
                            'Semprotan',
                          ],
                          onChanged: (val) =>
                              setState(() => _dosisSatuan = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Lama Konsumsi:'),
                        MedsTextField(
                          controller: _lamaKonsumsiAngkaCtrl,
                          hint: 'Ex: 3',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Waktu:'),
                        _buildDropdown(
                          value: _lamaKonsumsiSatuan,
                          items: ['hari', 'minggu', 'bulan', 'tahun'],
                          onChanged: (val) =>
                              setState(() => _lamaKonsumsiSatuan = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Periode Minum:'),
                        _buildDropdown(
                          value: _periodeMinum,
                          items: ['Setiap Hari', 'Hari Pilihan'],
                          onChanged: (val) =>
                              setState(() => _periodeMinum = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Berapa Kali Sehari:'),
                        _buildDropdown(
                          value: _frekuensi,
                          items: ['1', '2', '3', '4', '5'],
                          onChanged: (val) => setState(() => _frekuensi = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const MedsLabel('Aturan Minum:'),
              _buildDropdown(
                value: _aturanMinum,
                items: [
                  'Sebelum tidur',
                  'Setelah makan',
                  'Sebelum makan',
                  'Setelah bangun tidur',
                  'Saat Makan',
                ],
                onChanged: (val) => setState(() => _aturanMinum = val!),
              ),
              const SizedBox(height: 20),

              const MedsLabel('Waktu Pengingat (Time to take):'),
              MedsTimeInput(hourCtrl: _hourCtrl, minCtrl: _minuteCtrl),
              const SizedBox(height: 20),

              const MedsLabel('Catatan (Opsional):'),
              MedsTextField(
                controller: _notesCtrl,
                hint: 'Tambahkan catatan jika ada...',
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final int hour = int.tryParse(_hourCtrl.text) ?? 0;
                    final int minute = int.tryParse(_minuteCtrl.text) ?? 0;

                    String determinedCategory = 'Night';
                    if (hour >= 5 && hour < 12) {
                      determinedCategory = 'Morning';
                    } else if (hour >= 12 && hour < 17) {
                      determinedCategory = 'Afternoon';
                    } else if (hour >= 17 && hour < 20) {
                      determinedCategory = 'Evening';
                    }

                    final updatedMeds = Medicine(
                      id: widget.medicine.id, // TETAP GUNAKAN ID LAMA
                      title: _nameCtrl.text.isEmpty
                          ? 'Obat Baru'
                          : _nameCtrl.text,
                      latinName: '-',
                      type: _dosisSatuan,
                      quantity: '$_frekuensi Kali Sehari',
                      totalDosage: _aturanMinum,
                      remain: int.tryParse(_remainCtrl.text) ?? 0,
                      time: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        hour,
                        minute,
                      ),
                      isMeal: _aturanMinum.contains('makan'),
                      category: determinedCategory,
                      imageUrl: widget.medicine.imageUrl,
                      dosisLengkap: '${_dosisAngkaCtrl.text} $_dosisSatuan',
                      lamaKonsumsi:
                          '${_lamaKonsumsiAngkaCtrl.text} $_lamaKonsumsiSatuan',
                      periodeMinum: _periodeMinum,
                      catatan: _notesCtrl.text,
                    );

                    // LOGIKA MENGGANTI DATA LAMA DENGAN YANG BARU
                    final currentMeds = globalMedicinesNotifier.value;
                    final index = currentMeds.indexWhere(
                      (m) => m.id == updatedMeds.id,
                    );
                    if (index != -1) {
                      currentMeds[index] = updatedMeds;
                      globalMedicinesNotifier.value = List.from(
                        currentMeds,
                      ); // Trigger UI Update
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${updatedMeds.title} berhasil diperbarui!',
                        ),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
