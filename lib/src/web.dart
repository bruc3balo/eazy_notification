import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:eazy_notification/eazy_notification.dart';

class ProgressIndicatorBar {
  Function()? onProgressFinished;
  double? progressBarHeight;
  double? progressBarWidth;
  EdgeInsetsGeometry? progressBarPadding;
  Color? progressIndicatorBackground;
}

class NotificationAction {
  Widget action;
  dynamic Function() onActionPressed;

  NotificationAction({required this.action, required this.onActionPressed});
}

class NotificationCloseButton {
  Function() onClose;
  Widget Function(void Function()) closeButton;

  NotificationCloseButton({required this.onClose, required this.closeButton});
}

class NotificationStyle {
  Color shadowColor;
  Color background;
  double radius;
  bool enableShadow;
  NotificationPosition notificationPosition;
  AnimationType animation;
  Duration animationDuration;
  double iconSize;

  NotificationStyle({
    required this.shadowColor,
    required this.background,
    required this.radius,
    required this.enableShadow,
    required this.notificationPosition,
    required this.animation,
    required this.animationDuration,
    required this.iconSize,
  });
}

class WebNotificationService implements NotificationService {
  bool _showNotification({
    required BuildContext context,
    required WebOptions webOptions,
  }) {
    NotificationStyle? notificationStyle = webOptions.notificationStyle;
    ProgressIndicatorBar? progressBar = webOptions.progressIndicator;
    NotificationAction? notificationAction = webOptions.notificationAction;
    NotificationCloseButton? notificationCloseButton =
        webOptions.notificationCloseButton;

    ElegantNotification elegantNotification = ElegantNotification(
      title: webOptions.title,
      description: webOptions.description,
      icon: webOptions.icon,
      toastDuration:
          notificationStyle?.animationDuration ?? const Duration(seconds: 5),
      closeButton: notificationCloseButton?.closeButton,
      displayCloseButton: notificationCloseButton != null,
      onCloseButtonPressed: notificationCloseButton?.onClose,
      onDismiss: webOptions.onDismiss,
      autoDismiss: webOptions.autoDismiss,
      notificationPosition: notificationStyle?.notificationPosition ??
          NotificationPosition.topRight,
      action: notificationAction?.action,
      onActionPressed: notificationAction?.onActionPressed,
      animation: notificationStyle?.animation ?? AnimationType.fromRight,
      radius: notificationStyle?.radius ?? 5.0,
      shadowColor: notificationStyle?.shadowColor ?? greyColor,
      background: notificationStyle?.background ?? Colors.white,
      showProgressIndicator: progressBar != null,
      progressBarHeight: progressBar?.progressBarHeight,
      progressBarWidth: progressBar?.progressBarWidth,
      progressBarPadding: progressBar?.progressBarPadding,
      progressIndicatorBackground:
          progressBar?.progressIndicatorBackground ?? greyColor,
    );

    elegantNotification.show(context);
    return true;
  }

  @override
  Future<void> init() async {
    debugPrint("Web notifications initiated");
  }

  @override
  Future<bool> pushNotification(
      {required BuildContext context,
      MobileOptions? mobileOptions,
      WebOptions? webOptions,
      DesktopOptions? desktopOptions}) async {
    if (webOptions == null) {
      throw Exception("Provide webOptions options for WebNotificationService");
    }
    return _showNotification(context: context, webOptions: webOptions);
  }
}
