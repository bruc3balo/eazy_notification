library eazy_notification;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eazy_notification/src/web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';

export 'src/desktop.dart';
export 'src/mobile.dart';
export 'src/web.dart';
export 'package:mplatform/mplatform.dart';

abstract class EazyNotificationService {
  Future<void> init();

  Future<bool> pushNotification({
    required BuildContext context,
    MobileOptions? mobileOptions,
    WebOptions? webOptions,
    DesktopOptions? desktopOptions,
  });
}

class MobileOptions {
  NotificationChannel channel;
  int notificationId;
  String title;
  String message;
  bool requireInputText = false;
  bool wakeUpScreen = false;
  bool locked = false;
  bool autoDismissible = true;
  Duration? timeout;
  Duration? chronometer;
  ActionType actionType = ActionType.Default;
  NotificationLayout notificationLayout = NotificationLayout.BigText;
  NotificationCategory notificationCategory = NotificationCategory.Event;
  String? bigPicture;
  String? largeIcon;
  String? icon;
  Map<String, String?>? payload;
  List<NotificationActionButton> actions = const [];
  NotificationCalendar? schedule;
  Future<bool> Function()? hasAllowedPermissionRational;

  MobileOptions({
    required this.channel,
    required this.notificationId,
    required this.title,
    required this.message,
    this.requireInputText = false,
    this.wakeUpScreen = false,
    this.locked = false,
    this.autoDismissible = true,
    this.timeout,
    this.chronometer,
    this.actionType = ActionType.Default,
    this.notificationLayout = NotificationLayout.BigText,
    this.notificationCategory = NotificationCategory.Event,
    this.bigPicture,
    this.largeIcon,
    this.icon,
    this.payload,
    this.actions = const [],
    this.schedule,
    this.hasAllowedPermissionRational,
  });
}

class DesktopOptions {
  String notificationId;
  String title;
  String? subTitle;
  String message;
  bool silent;
  Function(LocalNotification)? onShow;
  Function(LocalNotificationCloseReason)? onClose;
  Function(LocalNotification)? onClick;
  Function(int)? onClickAction;

  DesktopOptions({
    required this.notificationId,
    required this.title,
    this.subTitle,
    required this.message,
    this.silent = true,
    this.onShow,
    this.onClose,
    this.onClick,
    this.onClickAction,
  });
}

class WebOptions {
  final Widget? title;
  final Widget description;
  final Widget icon;
  final Function() onDismiss;
  final ProgressIndicatorBar? progressIndicator;
  final NotificationAction? notificationAction;
  final NotificationCloseButton? notificationCloseButton;
  final NotificationStyle? notificationStyle;

  // final NotificationType notificationType;
  final bool autoDismiss;

  WebOptions({
    this.title,
    required this.description,
    required this.icon,
    required this.onDismiss,
    this.progressIndicator,
    this.notificationAction,
    this.notificationCloseButton,
    this.notificationStyle,
    // this.notificationType = NotificationType.info,
    this.autoDismiss = true,
  });
}
