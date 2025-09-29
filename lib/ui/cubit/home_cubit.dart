import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/task.dart';
import '../../data/repo/taskdao_repo.dart';

class HomeCubit extends Cubit<List<Task>> {
  HomeCubit() : super([]);

  final repo = TaskDaoRepo();

  void listenTasks() {
    repo.getAllTasksStream().listen((tasks) {
      emit(tasks);
    });
  }

  Future<void> toggleDone(Task task) async {
    await repo.toggleDone(task);
  }

  Future<void> deleteTask(String id) async {
    await repo.deleteTask(id);
  }
}
