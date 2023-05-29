import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationPlugin {
  static LocalNotificationPlugin instance = LocalNotificationPlugin();
  static final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String? payload) async {
    print("****");
  }

  void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
    );
    notificationPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 100000000000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "default_notification_channel_id", "vikrayChannel",
            channelDescription: "These is Vikray channel",
            importance: Importance.max,
            priority: Priority.high),
      );
/*
*Creates the notification channel when it runs first time
*Call back for on select notification
*/
      await notificationPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: "");
    } catch (error) {
      rethrow;
    }
  }

  void backgroundDisplay(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
