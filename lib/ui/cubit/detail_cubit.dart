import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/taskdao_repo.dart';
import '../../data/entity/task.dart';
import '../../utils/notification_service.dart';

class DetailCubit extends Cubit<void> {
  DetailCubit() : super(null);
  final repo = TaskDaoRepo();

  Future<void> updateTask(Task task) async {
    await repo.updateTask(task);

    if (task.id != null && task.dueDate != null) {
      await NotificationService.scheduleTaskNotifications(
        task.id!,
        task.title,
        task.dueDate!,
      );
    } else if (task.id != null) {
      await NotificationService.cancelTaskNotifications(task.id!);
    }
  }

  Future<void> deleteTask(String id) async {
    await repo.deleteTask(id);
    await NotificationService.cancelTaskNotifications(id);
  }
}
