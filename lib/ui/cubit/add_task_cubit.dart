import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/taskdao_repo.dart';
import '../../data/entity/task.dart';
import '../../utils/notification_service.dart';




class AddTaskCubit extends Cubit<void> {
  AddTaskCubit() : super(null);
  final repo = TaskDaoRepo();

  Future<void> addTask(
      String title,
      String description,
      DateTime dueDate,
      String category,
      ) async {
    final task = Task(
      title: title,
      description: description,
      dueDate: dueDate,
      category: category,
    );
    
    // Add task to repository and get the document ID
    final taskId = await repo.addTask(task);
    
    // Schedule notifications for the task if it has a due date
    if (taskId != null && task.dueDate != null) {
      await NotificationService.scheduleTaskNotifications(
        taskId, 
        task.title, 
        task.dueDate!,
      );
    }
  }

}
