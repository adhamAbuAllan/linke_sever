import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:link_sever/main.dart';
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the notifications plugin with the new callback
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationSelected,  // Updated method for tap handling
    );
  }

  Future<void> _onNotificationSelected(NotificationResponse response) async {
    // When the notification is tapped, navigate to the specific screen
    // You can check for the payload and handle navigation accordingly

    if (response.payload != null) {
      print('Notification payload: ${response.payload}');
      // If you are using Navigator, navigate to the desired screen
      // Example navigation to the UrlDetectorScreen
      // Replace this with the appropriate navigation logic for your app
      Navigator.of(navigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (context) => UrlDetectorScreen(),
        ),
      );
    }
  }

  Future<void> showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'url_detector_channel',
      'URL Detector',
      channelDescription: 'Notifies user to save a URL',
      importance: Importance.high,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    // You can pass a payload that you can later use to navigate when the notification is tapped
    await flutterLocalNotificationsPlugin.show(
      0,
      'URL Detector',
      message,
      platformDetails,
      payload: 'url_detector_payload',  // Here you can send any payload if needed
    );
  }
}
