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
  final _dosageCtrl = TextEditingController();
  final _hourCtrl = TextEditingController();
  final _minuteCtrl = TextEditingController();
  final _periodLengthCtrl = TextEditingController();

  String _dosageType = 'Capsule';
  String _periodUnit = 'Day';
  int _dosagePerDay = 1;
  bool _isAfterMeal = false;

  @override
  void initState() {
    super.initState();
    _hourCtrl.text = '00';
    _minuteCtrl.text = '00';
    _periodLengthCtrl.text = '00';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    _periodLengthCtrl.dispose();
    super.dispose();
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
                'Manual Fill:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),

              const MedsLabel('Name:'),
              MedsTextField(controller: _nameCtrl, hint: 'Medicine Name...'),
              const SizedBox(height: 20),

              const MedsLabel('Total Dosage:'),
              MedsDosageField(
                controller: _dosageCtrl,
                value: _dosageType,
                onChanged: (val) => setState(() => _dosageType = val!),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Time to take:'),
                        MedsTimeInput(
                          hourCtrl: _hourCtrl,
                          minCtrl: _minuteCtrl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Dosage/Day'),
                        MedsCounter(
                          value: _dosagePerDay,
                          onIncrement: () => setState(() => _dosagePerDay++),
                          onDecrement: () => setState(() {
                            if (_dosagePerDay > 1) _dosagePerDay--;
                          }),
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
                        const MedsLabel('Period:'),
                        // Panggil MedsPeriodInput dengan parameter Dropdown yang baru
                        MedsPeriodInput(
                          lengthCtrl: _periodLengthCtrl,
                          unitValue: _periodUnit,
                          onUnitChanged: (val) {
                            if (val != null) {
                              setState(() => _periodUnit = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MedsLabel('Instruction'),
                        MedsInstructionDropdown(
                          isAfterMeal: _isAfterMeal,
                          onChanged: (val) =>
                              setState(() => _isAfterMeal = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
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

              // DI FILE: lib/screen/add_meds_manual_screen.dart

              // (Pastikan kamu meng-import ini di atas)
              // import 'package:remindy_app/data/dummy_data.dart';
              // import 'package:remindy_app/models/medicine.dart';

              // ... (kode form di atasnya) ...
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Ambil nilai jam & menit dari teks controller, default 0 jika kosong/error
                    final int hour = int.tryParse(_hourCtrl.text) ?? 0;
                    final int minute = int.tryParse(_minuteCtrl.text) ?? 0;

                    // 2. Tentukan kategori otomatis berdasarkan Jam!
                    String determinedCategory = 'Night';
                    if (hour >= 5 && hour < 12) {
                      determinedCategory = 'Morning';
                    } else if (hour >= 12 && hour < 17) {
                      determinedCategory = 'Afternoon';
                    } else if (hour >= 17 && hour < 20) {
                      determinedCategory = 'Evening';
                    }

                    // 3. Buat obyek obat baru dengan nilai dari input form
                    final newMeds = Medicine(
                      id: DateTime.now().millisecondsSinceEpoch
                          .toString(), // Bikin ID acak
                      title: _nameCtrl.text.isEmpty
                          ? 'New Medicine'
                          : _nameCtrl.text,
                      latinName: '-', // Bebas
                      type: _dosageType,
                      quantity: '$_dosagePerDay $_dosageType',
                      totalDosage:
                          '${_dosageCtrl.text.isEmpty ? '0' : _dosageCtrl.text} mg',
                      remain:
                          int.tryParse(_periodLengthCtrl.text) ??
                          0, // Sisa obat
                      // Gabungkan tanggal hari ini dengan jam input
                      time: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        hour,
                        minute,
                      ),
                      isMeal: _isAfterMeal,
                      category:
                          determinedCategory, // Kategori masuk otomatis dari logika if-else
                      imageUrl:
                          'https://images.unsplash.com/photo-1550572017-ed3c2c1a8264?q=80&w=1000&auto=format&fit=crop', // Gambar default
                    );

                    // 4. Masukkan ke dalam Global State (ValueNotifier)
                    addMedicine(newMeds);

                    // 5. Tutup form dan kembali ke layar sebelumnya
                    Navigator.pop(context);

                    // (Opsional) Tampilkan pesan sukses kecil
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${newMeds.title} berhasil ditambahkan!'),
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
            ],
          ),
        ),
      ),
    );
  }
}
