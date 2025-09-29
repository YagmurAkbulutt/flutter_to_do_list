import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _notifications.initialize(initSettings);
  }

  static Future<void> scheduleNotification(
      String title, DateTime dateTime) async {
    final scheduledTime = tz.TZDateTime.from(dateTime, tz.local)
        .subtract(const Duration(minutes: 30));

    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _notifications.zonedSchedule(
      dateTime.hashCode,
      "Yaklaşan Görev ⏰",
      "$title için son tarih yaklaşıyor!",
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Görev Bildirimleri',
          channelDescription: 'Yaklaşan görevler için bildirim gönderir',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle, // ✅ yeni zorunlu parametre
      matchDateTimeComponents: DateTimeComponents.time, // 🔔 opsiyonel ama faydalı
    );
  }
}
