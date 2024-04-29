import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  bool permissionStatus = false;
  bool _notificationsEnabled = false;

  static Future<void> initializeLocalNotifications() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'high_importance_channel',
              channelKey: 'high_importance_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white,
              channelShowBadge: true,
              onlyAlertOnce: true,
              playSound: true,
              criticalAlerts: true)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'high_importance_channel_group',
              channelGroupName: 'Group 1')
        ],
        debug: true);

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Action received: ${receivedAction.id}');
    final payload = receivedAction.payload ?? {};
    if (payload['action'] == 'openEvent') {
      debugPrint('Open event action received');
    }
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('dismissAction created: ${receivedAction.id}');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification display methode: ${receivedAction.id}');
  }

  Future<void> sendNotification(
      {required final String title,
      required final String body,
      final String? summary,
      final Map<String, String>? payload,
      final ActionType actionType = ActionType.Default,
      final NotificationLayout notificationLayout = NotificationLayout.Default,
      final NotificationCategory? notificationCategory,
      final String? bigPicture,
      final List<NotificationActionButton>? actionButtons,
      final bool schedule = false,
      final int? interval}) async {
    if (_notificationsEnabled) {
      assert(!schedule || (schedule && interval != null));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'high_importance_channel',
          title: title,
          body: body,
          summary: summary,
          payload: payload,
          category: notificationCategory,
          bigPicture: bigPicture,
        ),
        actionButtons: actionButtons,
        schedule: schedule
            ? NotificationInterval(
                interval: interval,
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true)
            : null,
      );
    }
  }

  void checkPermissions() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void turnOnPermissions() async {
    _notificationsEnabled = true;
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void turnOff() async {
    AwesomeNotifications().cancelAll();
    _notificationsEnabled = false;
  }
}
