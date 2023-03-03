import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));

    requestNotificationPermissions();
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await _localNotificationService.initialize(initializationSettings);
    } catch (e) {
      print('Error initializing notification plugin: $e');
    }
  }

  Future<void> scheduledNotification(
      {required int id,
      required String title,
      required String body,
      required String date}) async {

    DateTime now = DateTime.now();
    DateTime future = DateTime.parse(date);
    int seconds = future.difference(now).inSeconds < 0
        ? 60
        : future.difference(now).inSeconds;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails notificationDetails =
        const NotificationDetails(android: androidNotificationDetails);

    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> requestNotificationPermissions() async {
    if (await Permission.notification.status != PermissionStatus.granted) {
      await Permission.notification.request();
    }
  }
}
