import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/task.dart';
import '../cubit/detail_cubit.dart';
import 'package:intl/intl.dart';


class DetailPage extends StatefulWidget {
  final Task task;
  const DetailPage({super.key, required this.task});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  DateTime? selectedDateTime;


  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.task.title);
    descCtrl = TextEditingController(text: widget.task.description);
    selectedDateTime = widget.task.dueDate;
  }

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
    );

    if (time == null) return;

    final fullDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() => selectedDateTime = fullDateTime);
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Görev Detayı")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: titleCtrl),
              const SizedBox(height: 16),
              TextField(controller: descCtrl),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDateTime == null
                        ? "📅 Tarih/Saat seçilmedi"
                        : DateFormat('dd MMM yyyy, HH:mm').format(selectedDateTime!),
                  ),
                  TextButton.icon(
                    onPressed: pickDateTime,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Tarih & Saat Seç"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Kategori:"),
                  DropdownButton<String>(
                    value: widget.task.category,
                    items: const [
                      DropdownMenuItem(value: "İş", child: Text("İş")),
                      DropdownMenuItem(value: "Ev", child: Text("Ev")),
                      DropdownMenuItem(value: "Kişisel", child: Text("Kişisel")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          widget.task.category = value;
                        });
                      }
                    },
                  ),
                ],
              ),


              ElevatedButton.icon(
                icon: const Icon(Icons.update),
                label: const Text("Güncelle"),
                onPressed: () async {
                  final updated = widget.task
                    ..title = titleCtrl.text
                    ..description = descCtrl.text
                    ..dueDate = selectedDateTime;
                  await context.read<DetailCubit>().updateTask(updated);
                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
