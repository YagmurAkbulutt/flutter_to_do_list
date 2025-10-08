import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    // Android initialization
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(initSettings);
    
    // Request permissions
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    // Request notification permissions for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    // Request notification permissions for Android
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Schedules multiple notifications for a task
  /// - 1 day before (if applicable)
  /// - 1 hour before
  /// - 30 minutes before
  static Future<void> scheduleTaskNotifications(
      String taskId, String title, DateTime dueDate) async {
    final now = tz.TZDateTime.now(tz.local);
    
    // Cancel any existing notifications for this task
    await cancelTaskNotifications(taskId);
    
    // Schedule 1 day before notification
    final oneDayBefore = tz.TZDateTime.from(dueDate, tz.local)
        .subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(now)) {
      await _scheduleNotification(
        _getNotificationId(taskId, 'day'),
        'Görev Hatırlatması - 1 Gün Kaldı 📅',
        '$title görevi için son tarih yarın!',
        oneDayBefore,
      );
    }

    // Schedule 1 hour before notification
    final oneHourBefore = tz.TZDateTime.from(dueDate, tz.local)
        .subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      await _scheduleNotification(
        _getNotificationId(taskId, 'hour'),
        'Görev Hatırlatması - 1 Saat Kaldı ⏰',
        '$title görevi için son tarih 1 saat sonra!',
        oneHourBefore,
      );
    }

    // Schedule 30 minutes before notification
    final thirtyMinutesBefore = tz.TZDateTime.from(dueDate, tz.local)
        .subtract(const Duration(minutes: 30));
    if (thirtyMinutesBefore.isAfter(now)) {
      await _scheduleNotification(
        _getNotificationId(taskId, 'minutes'),
        'Görev Hatırlatması - 30 Dakika Kaldı ⚠️',
        '$title görevi için son tarih 30 dakika sonra!',
        thirtyMinutesBefore,
      );
    }
  }

  /// Schedules a single notification
  static Future<void> _scheduleNotification(
      int id, String title, String body, tz.TZDateTime scheduledTime) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Görev Bildirimleri',
          channelDescription: 'Yaklaşan görevler için bildirim gönderir',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'default',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Generates a unique notification ID for a task and timing
  static int _getNotificationId(String taskId, String timing) {
    return '${taskId}_$timing'.hashCode;
  }

  /// Cancels all notifications for a specific task
  static Future<void> cancelTaskNotifications(String taskId) async {
    await _notifications.cancel(_getNotificationId(taskId, 'day'));
    await _notifications.cancel(_getNotificationId(taskId, 'hour'));
    await _notifications.cancel(_getNotificationId(taskId, 'minutes'));
  }

  /// Cancels all scheduled notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Gets all pending notifications (for debugging)
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Legacy method for backwards compatibility
  @Deprecated('Use scheduleTaskNotifications instead')
  static Future<void> scheduleNotification(
      String title, DateTime dateTime) async {
    final taskId = title.hashCode.toString();
    await scheduleTaskNotifications(taskId, title, dateTime);
  }
}
