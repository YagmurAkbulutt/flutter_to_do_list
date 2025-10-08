import 'package:flutter/material.dart';

class DigitalTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeChanged;

  const DigitalTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  State<DigitalTimePicker> createState() => _DigitalTimePickerState();
}

class _DigitalTimePickerState extends State<DigitalTimePicker> {
  late int selectedHour;
  late int selectedMinute;
  late PageController hourController;
  late PageController minuteController;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;
    selectedMinute = widget.initialTime.minute;
    hourController = PageController(initialPage: selectedHour);
    minuteController = PageController(initialPage: selectedMinute);
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  void _updateTime() {
    widget.onTimeChanged(TimeOfDay(hour: selectedHour, minute: selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Saat Seçin',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B4EFF),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hour Picker
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4EFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: PageView.builder(
                  controller: hourController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      selectedHour = index % 24;
                    });
                    _updateTime();
                  },
                  itemBuilder: (context, index) {
                    final hour = index % 24;
                    return Center(
                      child: Text(
                        hour.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: hour == selectedHour
                              ? const Color(0xFF6B4EFF)
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                  itemCount: 72, // 24 * 3 for smooth scrolling
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Separator
              Text(
                ':',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6B4EFF),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Minute Picker
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4EFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: PageView.builder(
                  controller: minuteController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      selectedMinute = index % 60;
                    });
                    _updateTime();
                  },
                  itemBuilder: (context, index) {
                    final minute = index % 60;
                    return Center(
                      child: Text(
                        minute.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: minute == selectedMinute
                              ? const Color(0xFF6B4EFF)
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                  itemCount: 180, // 60 * 3 for smooth scrolling
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Digital Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6B4EFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}