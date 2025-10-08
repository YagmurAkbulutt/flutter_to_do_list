import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/task.dart';
import '../../data/repo/taskdao_repo.dart';
import '../../utils/notification_service.dart';

class HomeCubit extends Cubit<List<Task>> {
  HomeCubit() : super([]);

  final repo = TaskDaoRepo();

  void listenTasks() {
    repo.getAllTasksStream().listen((tasks) {
      // Sort tasks by date and time (nearest dates first)
      tasks.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1; // tasks without dates go to end
        if (b.dueDate == null) return -1; // tasks without dates go to end
        return a.dueDate!.compareTo(b.dueDate!);
      });
      emit(tasks);
    });
  }

  Future<void> toggleDone(Task task) async {
    await repo.toggleDone(task);
  }

  Future<void> deleteTask(String id) async {
    await repo.deleteTask(id);
    
    // Cancel all notifications for the deleted task
    await NotificationService.cancelTaskNotifications(id);
  }
}
