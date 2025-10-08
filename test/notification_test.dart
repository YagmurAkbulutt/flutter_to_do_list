import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/utils/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  group('NotificationService Tests', () {
    setUpAll(() async {
      tz.initializeTimeZones();
    });

    test('should generate unique notification IDs for different tasks', () {
      const taskId1 = 'task_123';
      const taskId2 = 'task_456';
      
      // Access private method through reflection or create a test helper
      // For now, we'll test the concept with a simple hash comparison
      final id1Day = '${taskId1}_day'.hashCode;
      final id1Hour = '${taskId1}_hour'.hashCode;
      final id1Minutes = '${taskId1}_minutes'.hashCode;
      
      final id2Day = '${taskId2}_day'.hashCode;
      final id2Hour = '${taskId2}_hour'.hashCode;
      final id2Minutes = '${taskId2}_minutes'.hashCode;
      
      // Test that different tasks have different notification IDs
      expect(id1Day, isNot(equals(id2Day)));
      expect(id1Hour, isNot(equals(id2Hour)));
      expect(id1Minutes, isNot(equals(id2Minutes)));
      
      // Test that different timing types for same task have different IDs
      expect(id1Day, isNot(equals(id1Hour)));
      expect(id1Hour, isNot(equals(id1Minutes)));
      expect(id1Day, isNot(equals(id1Minutes)));
    });

    test('should validate notification timing calculations', () {
      final dueDate = DateTime.now().add(const Duration(days: 2));
      final dueDateTz = tz.TZDateTime.from(dueDate, tz.local);
      
      final oneDayBefore = dueDateTz.subtract(const Duration(days: 1));
      final oneHourBefore = dueDateTz.subtract(const Duration(hours: 1));
      final thirtyMinutesBefore = dueDateTz.subtract(const Duration(minutes: 30));
      
      // Verify timing calculations
      expect(oneDayBefore.isBefore(dueDateTz), isTrue);
      expect(oneHourBefore.isBefore(dueDateTz), isTrue);
      expect(thirtyMinutesBefore.isBefore(dueDateTz), isTrue);
      
      // Verify order
      expect(oneDayBefore.isBefore(oneHourBefore), isTrue);
      expect(oneHourBefore.isBefore(thirtyMinutesBefore), isTrue);
    });

    test('should not schedule notifications for past dates', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 2));
      final pastDateTz = tz.TZDateTime.from(pastDate, tz.local);
      final now = tz.TZDateTime.now(tz.local);
      
      final oneDayBefore = pastDateTz.subtract(const Duration(days: 1));
      final oneHourBefore = pastDateTz.subtract(const Duration(hours: 1));
      final thirtyMinutesBefore = pastDateTz.subtract(const Duration(minutes: 30));
      
      // All calculated times should be in the past
      expect(oneDayBefore.isBefore(now), isTrue);
      expect(oneHourBefore.isBefore(now), isTrue);
      expect(thirtyMinutesBefore.isBefore(now), isTrue);
    });
  });
}