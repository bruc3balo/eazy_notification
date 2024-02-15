import 'dart:convert';

import 'package:eazy_notification/eazy_notification.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MobileNotificationService implements EazyNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool initialized = false;
  final String appIcon;

  MobileNotificationService({
    this.appIcon = '@mipmap/ic_launcher',
  });

  @override
  Future<void> init() async {
    if (initialized) return;

    // Initialize native android notification
     AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(appIcon);

    // Initialize native Ios Notifications
     DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();

     InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    initialized = await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
        ) ??
        false;
  }

  void showNotificationAndroid(MobileOptions mobileOptions) async {
    NotificationChannel channel = mobileOptions.channel;
    Importance importance = mobileOptions.importance;
    Priority priority = mobileOptions.priority;

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: importance,
      priority: priority,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      mobileOptions.notificationId,
      mobileOptions.title,
      mobileOptions.message,
      notificationDetails,
      payload: jsonEncode(mobileOptions.payload),
    );
  }

  void showNotificationIos(MobileOptions mobileOptions) async {
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: (mobileOptions.priority.index) > 2,
      presentBadge: true,
      presentSound: (mobileOptions.importance.index) > 2,
      presentBanner: true,
      presentList: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      mobileOptions.notificationId,
      mobileOptions.title,
      mobileOptions.message,
      notificationDetails,
      payload: jsonEncode(mobileOptions.payload),
    );
  }

  @override
  Future<bool> pushNotification({
    required BuildContext context,
    MobileOptions? mobileOptions,
    WebOptions? webOptions,
    DesktopOptions? desktopOptions,
  }) async {
    if (mobileOptions == null) {
      throw Exception("Provide mobile options for MobileNotificationService");
    }

    switch (Mplatform.current) {
      case Mplatform.android:
        showNotificationAndroid(mobileOptions);
        break;

      case Mplatform.ios:
        showNotificationIos(mobileOptions);
        break;

      default:
        return false;
    }

    return true;
  }
}
