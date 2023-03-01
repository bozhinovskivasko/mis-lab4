import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
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

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    NotificationDetails notificationDetails =
        const NotificationDetails(android: androidNotificationDetails);
    await _localNotificationService.show(id, title, body, notificationDetails);
  }

  Future<void> requestNotificationPermissions() async {
    if (await Permission.notification.status != PermissionStatus.granted) {
      await Permission.notification.request();
    }
  }
}
