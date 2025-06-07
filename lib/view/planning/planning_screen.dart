import 'package:flutter/material.dart';
import 'package:fast_rhino/common/colo_extension.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  DateTime _currentMonth = DateTime.now();
  int _selectedDay = DateTime.now().day;

  final List<Map<String, dynamic>> sessions = [
    {
      'checked': false,
      'title': "HIIT Session",
      'day': "Monday",
      'dayOfWeek': 1, // Monday
      'date': DateTime(2025, 6, 2),
      'time': "7:00 AM",
      'duration': "45 min",
      'intensity': "High Intensity",
      'intensityColor': highIntensityColor,
      'intensityTextColor': highIntensityText,
      'description': "High intensity interval training with 1 min sprint, 30 sec rest",
    },
    {
      'checked': true,
      'title': "Endurance Ride",
      'day': "Wednesday",
      'dayOfWeek': 3, // Wednesday
      'date': DateTime(2025, 6, 4),
      'time': "6:30 PM",
      'duration': "60 min",
      'intensity': "Medium Intensity",
      'intensityColor': mediumIntensityColor,
      'intensityTextColor': mediumIntensityText,
      'description': "Steady pace, focus on maintaining consistent output",
    },
    {
      'checked': false,
      'title': "Recovery Spin",
      'day': "Friday",
      'dayOfWeek': 5, // Friday
      'date': DateTime(2025, 6, 6),
      'time': "8:00 AM",
      'duration': "30 min",
      'intensity': "Low Intensity",
      'intensityColor': lowIntensityColor,
      'intensityTextColor': lowIntensityText,
      'description': "Light resistance, high cadence to promote recovery",
    },
  ];

  void _toggleChecked(int index) {
    setState(() {
      sessions[index]['checked'] = !(sessions[index]['checked'] as bool);
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _selectedDay = 1;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _selectedDay = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _CalendarHeader(
              currentMonth: _currentMonth,
              selectedDay: _selectedDay,
              onPrev: _goToPreviousMonth,
              onNext: _goToNextMonth,
              onDaySelected: (day) {
                setState(() {
                  _selectedDay = day;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  Text("Training Plan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add, size: 18),
                    label: Text("Add Session"),
                    style: TextButton.styleFrom(
                      foregroundColor: TColor.primaryColor1,
                      textStyle: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.93,
                      child: _SessionCard(
                        checked: session['checked'],
                        title: session['title'],
                        day: session['day'],
                        time: session['time'],
                        duration: session['duration'],
                        intensity: session['intensity'],
                        intensityColor: session['intensityColor'],
                        intensityTextColor: session['intensityTextColor'],
                        description: session['description'],
                        onToggleChecked: () => _toggleChecked(index),
                        onCancel: () {
                          setState(() {
                            sessions.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final int selectedDay;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Function(int) onDaySelected;

  const _CalendarHeader({
    required this.currentMonth,
    required this.selectedDay,
    required this.onPrev,
    required this.onNext,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final List<DateTime> days = List.generate(
      daysInMonth,
      (i) => DateTime(currentMonth.year, currentMonth.month, i + 1),
    );

    return Column(
      children: [
        // Month and navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: onPrev,
                child: Icon(Icons.chevron_left, size: 24),
              ),
              Spacer(),
              Text(
                "${_monthName(currentMonth.month)} ${currentMonth.year}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Spacer(),
              GestureDetector(
                onTap: onNext,
                child: Icon(Icons.chevron_right, size: 24),
              ),
            ],
          ),
        ),
        // Days as small cards
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: days.length,
            separatorBuilder: (_, __) => SizedBox(width: 6),
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day.day == selectedDay;
              final dayName = _shortWeekday(day.weekday);

              return GestureDetector(
                onTap: () => onDaySelected(day.day),
                child: Card(
                  color: isSelected ? TColor.primaryColor1 : Colors.white,
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(color: TColor.primaryColor1, width: 2)
                        : BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Container(
                    width: 44,
                    height: 54,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : TColor.primaryColor1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : TColor.primaryColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _shortWeekday(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }
}

class _SessionCard extends StatelessWidget {
  final bool checked;
  final String title, day, time, duration, intensity, description;
  final Color intensityColor, intensityTextColor;
  final VoidCallback onToggleChecked;
  final VoidCallback onCancel;

  const _SessionCard({
    required this.checked,
    required this.title,
    required this.day,
    required this.time,
    required this.duration,
    required this.intensity,
    required this.intensityColor,
    required this.intensityTextColor,
    required this.description,
    required this.onToggleChecked,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onToggleChecked,
                  child: checked
                      ? Icon(Icons.check_circle, color: Colors.green, size: 22)
                      : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 22),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Icon(Icons.more_vert, color: Colors.grey[600]),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(day, style: TextStyle(fontSize: 13)),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text("$time • $duration", style: TextStyle(fontSize: 13)),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: intensityColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                intensity,
                style: TextStyle(
                  color: intensityTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(description, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
            SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Edit"),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
                TextButton(
                  onPressed: onCancel,
                  child: Text("Cancel"),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Place your color constants at the top of this file or in your color extension file
const Color highIntensityColor = Color(0xFFFFEBEE);
const Color mediumIntensityColor = Color(0xFFFFF3E0);
const Color lowIntensityColor = Color(0xFFE8F5E9);

const Color highIntensityText = Color(0xFFD32F2F);
const Color mediumIntensityText = Color(0xFFF57C00);
const Color lowIntensityText = Color(0xFF388E3C);