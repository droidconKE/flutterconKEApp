import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;

@singleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationAction(response.payload);
      },
    );

    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'session_channel',
      'Session notifications',
      description: 'Notification channel for bookmarked sessions',
      importance: Importance.high,
      ledColor: Colors.white,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermission() async {
    // Android does not require explicit permission for notifications.
    // Permissions can be handled for iOS if needed.
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> createNotification(
    int id,
    String channelId,
    String title,
    String body,
  ) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'session_channel',
      'Session notifications',
      channelDescription: 'Notification channel for bookmarked sessions',
      importance: Importance.high,
      priority: Priority.high,
      color: ThemeColors.blueDroidconColor,
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(id, title, body, notificationDetails);
  }

  Future<void> createScheduledNotification({
    required String channelId,
    required LocalSession session,
  }) async {
    final notificationTime =
        session.endDateTime.subtract(const Duration(minutes: 5));
    final scheduledDate = tz.TZDateTime.from(
      notificationTime,
      tz.local,
    );

    const androidNotificationDetails = AndroidNotificationDetails(
      'session_channel',
      'Session notifications',
      channelDescription: 'Notification channel for bookmarked sessions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );

    String? title;
    String? body;

    if (channelId == 'session_channel') {
      title = '${session.title} feedback';
      body = 'Please provide feedback for the session you just attended: '
          '${session.title}';
    }

    if (title != null && body != null) {
      await _notificationsPlugin.zonedSchedule(
        session.id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        payload: session.slug,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  void _handleNotificationAction(String? payload) {
    Logger().f('Notification payload: $payload');
    if (payload != null && payload.isNotEmpty) {
      Logger().f('Navigating to feedback screen');
      getIt<FlutterConRouter>().config().push(
            FlutterConRouter.feedbackRoute,
            extra: payload,
          );
    }
  }
}
