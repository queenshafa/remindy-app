import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _periodUnitCtrl = TextEditingController(text: 'Day');

  String _dosageType = 'Capsule';
  int _dosagePerDay = 1;
  bool _isAfterMeal = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    _periodLengthCtrl.dispose();
    _periodUnitCtrl.dispose();
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
                        MedsPeriodInput(
                          lengthCtrl: _periodLengthCtrl,
                          unitCtrl: _periodUnitCtrl,
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

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {}, // TODO: Save Action
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
