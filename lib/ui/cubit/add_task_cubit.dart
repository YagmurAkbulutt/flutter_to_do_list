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
    await repo.addTask(task);
    await NotificationService.scheduleNotification(title, dueDate);
  }

}
