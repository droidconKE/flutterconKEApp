import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class NotificationService {
  Future<void> initNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'session_channel',
          channelName: 'Session notifications',
          channelDescription: 'Notification channel for bookmarked sessions',
          defaultColor: ThemeColors.blueDroidconColor,
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  Future<void> requestPermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((allowed) {
      if (!allowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> createNotification(
    int id,
    String channelKey,
    String title,
    String body,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
      ),
    );
  }

  Future<void> createScheduledNotification({
    required String channelKey,
    required LocalSession session,
  }) async {
    final endTime = session.endDateTime;
    final notificationTime = endTime.subtract(const Duration(minutes: 5));
    String? title;
    String? body;

    if (channelKey == 'session_channel') {
      title = '${session.title} feedback';
      body = 'Please provide feedback for the session you just attended:'
          ' ${session.title}';
    }

    if (title != null && body != null) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: session.id,
          channelKey: channelKey,
          title: title,
          body: body,
        ),
        schedule: NotificationCalendar.fromDate(date: notificationTime),
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    Logger().f(receivedAction);
    switch (receivedAction.channelKey) {
      case 'session_channel':
        FlutterConRouter.globalNavigatorKey.currentContext
            ?.pushReplacementNamed(FlutterConRouter.feedbackRoute);
    }
  }
}
