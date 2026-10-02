import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindy_app/data/dummy_data.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/circle_icon_button.dart';
import 'package:remindy_app/widgets/settings_bottom_sheet.dart';

class MedsHeader extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;

  const MedsHeader({super.key, this.onDateSelected});

  @override
  State<MedsHeader> createState() => _MedsHeaderState();
}

class _MedsHeaderState extends State<MedsHeader> {
  late DateTime _selectedDate;
  late List<DateTime> _daysList;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Set tanggal terpilih ke hari ini

    // Generate rentang hari (7 hari ke belakang dan 30 hari ke depan)
    _daysList = List.generate(38, (index) {
      return DateTime.now()
          .subtract(const Duration(days: 7))
          .add(Duration(days: index));
    });

    // Otomatis scroll ke posisi hari ini setelah widget selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const itemWidth = 58.0;
      const targetIndex = 7;

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(targetIndex * itemWidth - 40);
      }
    });
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BARIS PERTAMA: Header Judul & Tombol Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: globalUserNameNotifier,
                builder: (context, userName, child) {
                  return Text(
                    'Taking Meds,\n$userName?',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  );
                },
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: CircleIconButton(
                  icon: Icons.settings_outlined,
                  onTap: () {
                    SettingsBottomSheet.show(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // BARIS KEDUA: Kalender Horizontal
          SizedBox(
            height: 72,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _daysList.length,
              itemBuilder: (context, index) {
                final date = _daysList[index];

                final isSelected =
                    date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });

                    globalSelectedDateNotifier.value = date;

                    if (widget.onDateSelected != null) {
                      widget.onDateSelected!(date);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF7E7D7A)
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
