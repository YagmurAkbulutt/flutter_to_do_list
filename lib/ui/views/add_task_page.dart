import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ✅ DateFormat buradan geliyor
import 'package:to_do_list/ui/views/home_page.dart';
import '../cubit/add_task_cubit.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  DateTime? selectedDateTime;
  String selectedCategory = "Kişisel";


  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
      create: (_) => AddTaskCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Yeni Görev Ekle")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Başlık"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Açıklama"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Kategori:"),
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: const [
                      DropdownMenuItem(value: "İş", child: Text("İş")),
                      DropdownMenuItem(value: "Ev", child: Text("Ev")),
                      DropdownMenuItem(value: "Kişisel", child: Text("Kişisel")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedCategory = value);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedDateTime == null
                          ? "📅 Tarih/Saat seçilmedi"
                          : DateFormat('dd MMM yyyy, HH:mm')
                          .format(selectedDateTime!),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: pickDateTime,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Tarih & Saat Seç"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Kaydet"),
                  onPressed: () async {
                    if (titleCtrl.text.trim().isEmpty ||
                        selectedDateTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lütfen başlık ve tarih seçin."),
                        ),
                      );
                      return;
                    }

                    await context.read<AddTaskCubit>().addTask(
                        titleCtrl.text, descCtrl.text, selectedDateTime!,selectedCategory);

                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    }

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
