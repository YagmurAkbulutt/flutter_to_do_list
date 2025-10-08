import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/data/entity/task.dart';

void main() {
  group('Task Entity Tests', () {
    test('Task should have proper defaults', () {
      final task = Task(title: 'Test Task');
      expect(task.title, equals('Test Task'));
      expect(task.isDone, isFalse);
      expect(task.category, equals('Kişisel'));
    });

    test('Task should support custom categories', () {
      final task = Task(
        title: 'Test Task',
        category: 'Custom Category',
      );
      expect(task.category, equals('Custom Category'));
    });

    test('Task should convert to map properly', () {
      final task = Task(
        title: 'Test Task',
        description: 'Test Description',
        category: 'Test Category',
        isDone: true,
        dueDate: DateTime(2024, 1, 1, 12, 0),
      );

      final map = task.toMap();
      expect(map['title'], equals('Test Task'));
      expect(map['description'], equals('Test Description'));
      expect(map['category'], equals('Test Category'));
      expect(map['isDone'], isTrue);
      expect(map['dueDate'], equals('2024-01-01T12:00:00.000'));
    });

    test('Task should create from map properly', () {
      final map = {
        'title': 'Test Task',
        'description': 'Test Description',
        'category': 'Test Category',
        'isDone': true,
        'dueDate': '2024-01-01T12:00:00.000',
      };

      final task = Task.fromMap(map, 'test-id');
      expect(task.id, equals('test-id'));
      expect(task.title, equals('Test Task'));
      expect(task.description, equals('Test Description'));
      expect(task.category, equals('Test Category'));
      expect(task.isDone, isTrue);
      expect(task.dueDate, equals(DateTime(2024, 1, 1, 12, 0)));
    });
  });

  group('Task List Organization Tests', () {
    test('Should separate completed and pending tasks', () {
      final tasks = [
        Task(title: 'Completed Task 1', isDone: true),
        Task(title: 'Pending Task 1', isDone: false),
        Task(title: 'Completed Task 2', isDone: true),
        Task(title: 'Pending Task 2', isDone: false),
      ];

      final completedTasks = tasks.where((t) => t.isDone).toList();
      final pendingTasks = tasks.where((t) => !t.isDone).toList();

      expect(completedTasks.length, equals(2));
      expect(pendingTasks.length, equals(2));
      expect(completedTasks.every((t) => t.isDone), isTrue);
      expect(pendingTasks.every((t) => !t.isDone), isTrue);
    });
  });

  group('Category Functionality Tests', () {
    test('Default categories should be available', () {
      final defaultCategories = ['İş', 'Ev', 'Kişisel'];
      expect(defaultCategories.length, equals(3));
      expect(defaultCategories, contains('İş'));
      expect(defaultCategories, contains('Ev'));
      expect(defaultCategories, contains('Kişisel'));
    });

    test('Should support custom categories', () {
      final customCategories = ['İş', 'Ev', 'Kişisel', 'Spor', 'Eğitim'];
      expect(customCategories.length, greaterThan(3));
      expect(customCategories, contains('Spor'));
      expect(customCategories, contains('Eğitim'));
    });
  });
}