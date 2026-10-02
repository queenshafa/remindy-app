import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/models/medicine.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/add_meds_header.dart';
import 'package:remindy_app/widgets/meds_form_components.dart';

class AddMedsManualScreen extends StatefulWidget {
  const AddMedsManualScreen({super.key});

  @override
  State<AddMedsManualScreen> createState() => _AddMedsManualScreenState();
}

class _AddMedsManualScreenState extends State<AddMedsManualScreen> {
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
    _hourCtrl.text = '08';
    _minuteCtrl.text = '00';
    _remainCtrl.text = '30';
    _dosisAngkaCtrl.text = '1';
    _lamaKonsumsiAngkaCtrl.text = '7';
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
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
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
              const AddMedsHeader(),
              const SizedBox(height: 32),

              Text(
                'Manual Fill',
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

              // TOMBOL SIMPAN
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

                    final String newId = DateTime.now().millisecondsSinceEpoch
                        .toString();

                    final newMeds = Medicine(
                      id: newId,
                      title: _nameCtrl.text.isEmpty
                          ? 'New Medicine'
                          : _nameCtrl.text,
                      latinName: '-',
                      type: _dosisSatuan,
                      quantity:
                          '${_dosisAngkaCtrl.text} $_dosisSatuan', // Menampilkan dosis (misal: "1 Capsule") ke kartu
                      totalDosage:
                          _aturanMinum, // Aturan minum masuk ke sub-badge kartu
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
                      imageUrl:
                          'https://images.unsplash.com/photo-1584308666744-24d5e4b77f39?q=80&w=1000&auto=format&fit=crop',
                      dosisLengkap: '${_dosisAngkaCtrl.text} $_dosisSatuan',
                      lamaKonsumsi:
                          '${_lamaKonsumsiAngkaCtrl.text} $_lamaKonsumsiSatuan',
                      periodeMinum: _periodeMinum,
                      intervalHari: interval,
                      catatan: _notesCtrl.text,
                    );

                    addMedicine(newMeds);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${newMeds.title} added successfully!'),
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
                    'Add to Schedule',
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
