import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/entity/task.dart';
import '../cubit/home_cubit.dart';
import 'add_task_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedFilter = "Tümü";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..listenTasks(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Firebase To Do List"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // ✅ Kategori filtre butonları
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                spacing: 8,
                children: [
                  for (var category in ["Tümü", "İş", "Ev", "Kişisel"])
                    ChoiceChip(
                      label: Text(category),
                      selected: selectedFilter == category,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = category;
                        });
                      },
                    ),
                ],
              ),
            ),

            // ✅ Görev Listesi
            Expanded(
              child: BlocBuilder<HomeCubit, List<Task>>(
                builder: (context, tasks) {
                  if (tasks.isEmpty) {
                    return const Center(child: Text("Henüz görev yok ☁️"));
                  }

                  // Seçilen kategoriye göre filtreleme
                  final filteredTasks = selectedFilter == "Tümü"
                      ? tasks
                      : tasks
                      .where((t) => t.category == selectedFilter)
                      .toList();

                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Text(
                        "$selectedFilter kategorisinde görev yok 🙌",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (_) =>
                                context.read<HomeCubit>().toggleDone(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (task.description != null &&
                                  task.description!.isNotEmpty)
                                Text(task.description!),
                              if (task.dueDate != null)
                                Text(
                                  "🗓️ ${DateFormat('dd MMM yyyy, HH:mm').format(task.dueDate!)}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              Text(
                                "Kategori: ${task.category}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                context.read<HomeCubit>().deleteTask(task.id!),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(task: task),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // ✅ Yeni görev ekleme butonu
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
