import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';

class MedsLabel extends StatelessWidget {
  final String text;
  const MedsLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

class MedsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const MedsTextField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary, // Pastikan ini warna teks utamamu
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
        filled: true,
        fillColor: Colors.white, // Background putih langsung dari TextField-nya
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        // Border saat diam (tanpa garis)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        // Border utama (tanpa garis)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        // Border saat diklik/fokus (garis merah rapi mengikuti bentuk kotak)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppTheme.primary, // Garis merah rapi dari tema kamu
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class MedsDosageField extends StatelessWidget {
  final TextEditingController controller;
  final String value;
  final ValueChanged<String?> onChanged;
  const MedsDosageField({
    super.key,
    required this.controller,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.only(left: 20, right: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Total dosage',
              border: InputBorder.none,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        ),
        Container(width: 1.5, height: 24, color: AppTheme.primary),
        const SizedBox(width: 12),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.black87,
            ),
            items: ['Capsule', 'Tablet', 'Pill', 'ml']
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}

// 4. Pill Input Waktu (Dilengkapi validasi Jam 00-23 dan Menit 00-59)

class MedsTimeInput extends StatefulWidget {
  final TextEditingController hourCtrl;
  final TextEditingController minCtrl;

  const MedsTimeInput({
    super.key,
    required this.hourCtrl,
    required this.minCtrl,
  });

  @override
  State<MedsTimeInput> createState() => _MedsTimeInputState();
}

class _MedsTimeInputState extends State<MedsTimeInput> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = _readTime();
    _syncControllers();
  }

  TimeOfDay _readTime() {
    final hour = int.tryParse(widget.hourCtrl.text) ?? 0;
    final minute = int.tryParse(widget.minCtrl.text) ?? 0;

    return TimeOfDay(
      hour: hour.clamp(0, 23).toInt(),
      minute: minute.clamp(0, 59).toInt(),
    );
  }

  void _syncControllers() {
    widget.hourCtrl.text = _selectedTime.hour.toString().padLeft(2, '0');
    widget.minCtrl.text = _selectedTime.minute.toString().padLeft(2, '0');
  }

  Future<void> _showTimePicker() async {
    final now = DateTime.now();
    final initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final pickedTime = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) =>
          _CupertinoTimePickerSheet(initialDateTime: initialDateTime),
    );

    if (pickedTime == null || !mounted) return;

    setState(() {
      _selectedTime = TimeOfDay.fromDateTime(pickedTime);
      _syncControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _BasePill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showTimePicker,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.clock,
                  size: 20,
                  color: Colors.black54,
                ),
                const SizedBox(width: 12),
                Text(
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:'
                  '${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  CupertinoIcons.chevron_down,
                  size: 14,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Native-style iOS time picker bottom sheet
class _CupertinoTimePickerSheet extends StatefulWidget {
  final DateTime initialDateTime;

  const _CupertinoTimePickerSheet({required this.initialDateTime});

  @override
  State<_CupertinoTimePickerSheet> createState() =>
      _CupertinoTimePickerSheetState();
}

class _CupertinoTimePickerSheetState extends State<_CupertinoTimePickerSheet> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Sheet handle
              Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey3,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Navigation bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const Expanded(
                      child: Text(
                        'Time',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.label,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context, _selectedDateTime);
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // iOS wheel picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  minuteInterval: 1,
                  initialDateTime: widget.initialDateTime,
                  onDateTimeChanged: (dateTime) {
                    _selectedDateTime = dateTime;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. Pill Counter
class MedsCounter extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement, onDecrement;
  const MedsCounter({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });
  @override
  Widget build(BuildContext context) => _BasePill(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: onIncrement,
          child: const _CircleIconBtn(Icons.arrow_upward),
        ),
        Text(
          '$value',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onDecrement,
          child: const _CircleIconBtn(Icons.arrow_downward),
        ),
      ],
    ),
  );
}

// 6. Pill Periode (Angka Bebas & Dropdown Days/Months/Years)
class MedsPeriodInput extends StatelessWidget {
  final TextEditingController lengthCtrl;
  final String unitValue;
  final ValueChanged<String?> onUnitChanged;
  const MedsPeriodInput({
    super.key,
    required this.lengthCtrl,
    required this.unitValue,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) => _BasePill(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleInput(
          lengthCtrl,
          '00',
          limit: 4,
        ), // Bisa input angka sampai ribuan (4 digit)
        // Custom Dropdown untuk Periode
        Container(
          height: 44,
          padding: const EdgeInsets.only(left: 12, right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(22),
          ),
          alignment: Alignment.center,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: unitValue,
              isDense: true,
              icon: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.black87,
                ),
              ),
              items: ['Day', 'Week', 'Month', 'Year']
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onUnitChanged,
            ),
          ),
        ),
      ],
    ),
  );
}

// 7. Pill Dropdown Instruksi Makan
class MedsInstructionDropdown extends StatelessWidget {
  final bool isAfterMeal;
  final ValueChanged<bool?> onChanged;
  const MedsInstructionDropdown({
    super.key,
    required this.isAfterMeal,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => _BasePill(
    child: Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<bool>(
          value: isAfterMeal,
          isExpanded: true,
          icon: const _CircleIconBtn(Icons.arrow_downward),
          items: const [
            DropdownMenuItem(
              value: false,
              child: Text(
                'Before Meal',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            DropdownMenuItem(
              value: true,
              child: Text(
                'After Meal',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

// --- PRIVATE HELPERS ---
class _BasePill extends StatelessWidget {
  final Widget child;
  const _BasePill({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
    ),
    child: child,
  );
}

// Bulatan Input Teks (Ditambah fitur `maxValue` untuk pembatasan validasi waktu)
class _CircleInput extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final int limit;
  final int? maxValue; // Batas atas (contoh: 23 atau 59)

  const _CircleInput(this.ctrl, this.hint, {this.limit = 2}) : maxValue = null;

  @override
  Widget build(BuildContext context) => Container(
    width: limit > 2 ? 52 : 44,
    height: 44,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFFE5E5E5),
      borderRadius: BorderRadius.circular(22),
    ),
    child: TextField(
      controller: ctrl,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(limit),
        if (maxValue != null)
          _MaxRangeFormatter(
            maxValue!,
          ), // <-- Formatter khusus waktu dipanggil di sini!
      ],
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  const _CircleIconBtn(this.icon);
  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: const BoxDecoration(
      color: Color(0xFFE5E5E5),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 20, color: Colors.black87),
  );
}

// --- CUSTOM FORMATTER UNTUK WAKTU ---
// Mencegah input angka melebihi batas (misal tidak bisa ngetik "25" di jam)
class _MaxRangeFormatter extends TextInputFormatter {
  final int max;
  _MaxRangeFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    // Tolak inputan kalau huruf/spasi (null) atau nilainya lebih dari max (misal 24 atau 60)
    if (value == null || value > max) {
      return oldValue;
    }
    return newValue;
  }
}
