import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/taskdao_repo.dart';
import '../../data/entity/task.dart';

class DetailCubit extends Cubit<void> {
  DetailCubit() : super(null);
  final repo = TaskDaoRepo();

  Future<void> updateTask(Task task) async {
    await repo.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await repo.deleteTask(id);
  }
}
