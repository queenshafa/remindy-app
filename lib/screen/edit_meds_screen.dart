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
  String _lamaKonsumsiSatuan = 'Days';
  String _periodeMinum = 'Everyday';
  String _aturanMinum = 'After meal';

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

    // Parse Data Dosis (contoh: "1 Tablet" -> "1", "Tablet")
    final dosisParts = (med.dosisLengkap ?? '1 Tablet').split(' ');
    _dosisAngkaCtrl.text = dosisParts.isNotEmpty ? dosisParts[0] : '1';
    final parsedDosisSatuan = dosisParts.length > 1 ? dosisParts[1] : 'Tablet';
    if ([
      'Suppository',
      'Tablet',
      'Drops',
      'Caplet',
      'Capsule',
      'Pill',
      'Spray',
    ].contains(parsedDosisSatuan)) {
      _dosisSatuan = parsedDosisSatuan;
    }

    // Parse Data Lama Konsumsi (contoh: "7 Days" -> "7", "Days")
    final lamaParts = (med.lamaKonsumsi ?? '7 Days').split(' ');
    _lamaKonsumsiAngkaCtrl.text = lamaParts.isNotEmpty ? lamaParts[0] : '7';
    final parsedLamaSatuan = lamaParts.length > 1 ? lamaParts[1] : 'Days';
    if (['Days', 'Weeks', 'Months', 'Years'].contains(parsedLamaSatuan)) {
      _lamaKonsumsiSatuan = parsedLamaSatuan;
    }

    // Parse Periode Minum
    if ([
      'Everyday',
      'Every 2 Days',
      'Every 3 Days',
      'Once a Week',
    ].contains(med.periodeMinum)) {
      _periodeMinum = med.periodeMinum!;
    }

    // Parse Aturan Minum
    if ([
      'Before bed',
      'After meal',
      'Before meal',
      'After waking up',
      'With meal',
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
                'Edit Medicine',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),

              const MedsLabel('Medicine Name:'),
              MedsTextField(controller: _nameCtrl, hint: 'e.g. Paracetamol'),
              const SizedBox(height: 20),

              const MedsLabel('Remaining Stock (Bottles/Strips):'),
              MedsTextField(controller: _remainCtrl, hint: 'e.g. 30'),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Dosage:'),
                        MedsTextField(controller: _dosisAngkaCtrl, hint: '1'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Unit:'),
                        _buildDropdown(
                          value: _dosisSatuan,
                          items: [
                            'Suppository',
                            'Tablet',
                            'Drops',
                            'Caplet',
                            'Capsule',
                            'Pill',
                            'Spray',
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
                        const MedsLabel('Duration:'),
                        MedsTextField(
                          controller: _lamaKonsumsiAngkaCtrl,
                          hint: '3',
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
                        const MedsLabel('Period Unit:'),
                        _buildDropdown(
                          value: _lamaKonsumsiSatuan,
                          items: ['Days', 'Weeks', 'Months', 'Years'],
                          onChanged: (val) =>
                              setState(() => _lamaKonsumsiSatuan = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const MedsLabel('Drinking Frequency / Interval:'),
              _buildDropdown(
                value: _periodeMinum,
                items: [
                  'Everyday',
                  'Every 2 Days',
                  'Every 3 Days',
                  'Once a Week',
                ],
                onChanged: (val) => setState(() => _periodeMinum = val!),
              ),
              const SizedBox(height: 20),

              const MedsLabel('Instruction:'),
              _buildDropdown(
                value: _aturanMinum,
                items: [
                  'Before bed',
                  'After meal',
                  'Before meal',
                  'After waking up',
                  'With meal',
                ],
                onChanged: (val) => setState(() => _aturanMinum = val!),
              ),
              const SizedBox(height: 20),

              const MedsLabel('Time to take:'),
              MedsTimeInput(hourCtrl: _hourCtrl, minCtrl: _minuteCtrl),
              const SizedBox(height: 20),

              const MedsLabel('Notes (Optional):'),
              MedsTextField(controller: _notesCtrl, hint: 'Add notes here...'),
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

                    int interval = 1;
                    if (_periodeMinum == 'Every 2 Days') interval = 2;
                    if (_periodeMinum == 'Every 3 Days') interval = 3;
                    if (_periodeMinum == 'Once a Week') interval = 7;

                    final updatedMeds = Medicine(
                      id: widget.medicine.id, // Tetap gunakan ID lama
                      title: _nameCtrl.text.isEmpty
                          ? 'New Medicine'
                          : _nameCtrl.text,
                      type: _dosisSatuan,
                      quantity: '${_dosisAngkaCtrl.text} $_dosisSatuan',
                      totalDosage: _aturanMinum,
                      remain: int.tryParse(_remainCtrl.text) ?? 0,
                      time: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        hour,
                        minute,
                      ),
                      isMeal: _aturanMinum.toLowerCase().contains('meal'),
                      category: determinedCategory,
                      imageUrl: widget.medicine.imageUrl,
                      dosisLengkap: '${_dosisAngkaCtrl.text} $_dosisSatuan',
                      lamaKonsumsi:
                          '${_lamaKonsumsiAngkaCtrl.text} $_lamaKonsumsiSatuan',
                      periodeMinum: _periodeMinum,
                      intervalHari: interval,
                      catatan: _notesCtrl.text,
                      consumedDates: widget.medicine.consumedDates,
                    );

                    // Update data di global state
                    final currentMeds = globalMedicinesNotifier.value;
                    final index = currentMeds.indexWhere(
                      (m) => m.id == updatedMeds.id,
                    );
                    if (index != -1) {
                      currentMeds[index] = updatedMeds;
                      globalMedicinesNotifier.value = List.from(currentMeds);
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${updatedMeds.title} updated successfully!',
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
