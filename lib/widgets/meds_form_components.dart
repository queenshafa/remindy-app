import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/theme/app_theme.dart';

// 1. Label Teks
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

// 2. TextField Biasa (Untuk Nama)
class MedsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const MedsTextField({
    super.key,
    required this.controller,
    required this.hint,
  });
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
    ),
  );
}

// 3. Field Dosis & Dropdown Unit Obat
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
    padding: const EdgeInsets.only(left: 20, right: 12),
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
            decoration: InputDecoration(
              hintText: 'Total dosage',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        ),
        Container(width: 2, height: 24, color: AppTheme.primary),
        const SizedBox(width: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
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

// 4. Pill Input Waktu (00 : 00)
class MedsTimeInput extends StatelessWidget {
  final TextEditingController hourCtrl, minCtrl;
  const MedsTimeInput({
    super.key,
    required this.hourCtrl,
    required this.minCtrl,
  });
  @override
  Widget build(BuildContext context) => _BasePill(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_CircleInput(hourCtrl, '00'), _CircleInput(minCtrl, '00')],
    ),
  );
}

// 5. Pill Counter Dosis per Hari
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

// 6. Pill Periode (00 Day)
class MedsPeriodInput extends StatelessWidget {
  final TextEditingController lengthCtrl, unitCtrl;
  const MedsPeriodInput({
    super.key,
    required this.lengthCtrl,
    required this.unitCtrl,
  });
  @override
  Widget build(BuildContext context) => _BasePill(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleInput(lengthCtrl, '00'),
        _CircleInput(unitCtrl, 'Day', isTextOnly: true),
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
    child: DropdownButtonHideUnderline(
      child: DropdownButton<bool>(
        value: isAfterMeal,
        isExpanded: true,
        icon: const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
        items: const [
          DropdownMenuItem(
            value: false,
            child: Center(
              child: Text(
                'Before Meal',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
          DropdownMenuItem(
            value: true,
            child: Center(
              child: Text(
                'After Meal',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    ),
  );
}

// --- PRIVATE HELPERS (Hanya dipakai di dalam file ini) ---
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

class _CircleInput extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final bool isTextOnly;
  const _CircleInput(this.ctrl, this.hint, {this.isTextOnly = false});
  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: Color(0xFFE5E5E5),
      shape: BoxShape.circle,
    ),
    child: TextField(
      controller: ctrl,
      textAlign: TextAlign.center,
      keyboardType: isTextOnly ? TextInputType.text : TextInputType.number,
      inputFormatters: isTextOnly ? [] : [LengthLimitingTextInputFormatter(2)],
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
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
    child: Icon(icon, size: 20, color: Colors.grey.shade700),
  );
}
