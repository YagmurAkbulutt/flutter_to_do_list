import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/task.dart';

class TaskDaoRepo {
  final CollectionReference tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  Future<String?> addTask(Task task) async {
    final docRef = await tasksRef.add(task.toMap());
    return docRef.id;
  }

  Stream<List<Task>> getAllTasksStream() {
    return tasksRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateTask(Task task) async {
    if (task.id != null) {
      await tasksRef.doc(task.id).update(task.toMap());
    }
  }

  Future<void> deleteTask(String id) async {
    await tasksRef.doc(id).delete();
  }

  Future<void> toggleDone(Task task) async {
    if (task.id != null) {
      await tasksRef.doc(task.id).update({'isDone': !task.isDone});
    }
  }
}
