/*
// import 'dart:isolate';
export 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eazy_notification/eazy_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MobileNotificationService implements EazyNotificationService {
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  late final ReceivedAction? initialAction;
  bool initialized = false;
  final String? appIcon;
  final String? languageCode;
  final List<NotificationChannel> channels;
  final List<NotificationChannelGroup> channelGroups;

  MobileNotificationService({
    this.appIcon,
    this.languageCode,
    required this.channels,
    this.channelGroups = const [],
  });

  @override
  Future<void> init() async {
    if (initialized) return;
    WidgetsFlutterBinding.ensureInitialized();
    initialized = await awesomeNotifications.initialize(
      appIcon,
      channels,
      channelGroups: channelGroups,
      debug: kReleaseMode,
      languageCode: languageCode,
    );

    //Initial action
    initialAction = await awesomeNotifications.getInitialNotificationAction(
      removeFromActionEvents: false,
    );

    //Notifications events are only delivered after call this method
    await awesomeNotifications.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );

    debugPrint("Mobile notifications initiated");
  }

  ///  NOTIFICATION EVENTS
  @pragma('vm:entry-point')
  Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // For background actions, you must hold the execution until the end
    switch (receivedAction.actionType) {
      case ActionType.Default:
      case ActionType.DisabledAction:
      case ActionType.DismissAction:
      case ActionType.SilentBackgroundAction:
      case ActionType.SilentAction:
      case ActionType.KeepOnTop:
        debugPrint(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"',
        );
        // await executeLongTaskInBackground();
        // goToRoute(routeName: "/");
        break;

      case null:
      default:
        break;
    }
  }

  @pragma('vm:entry-point')
  Future<void> onNotificationCreatedMethod(
      ReceivedNotification notification) async {
    // For background actions, you must hold the execution until the end
    switch (notification.actionType) {
      case ActionType.Default:
      case ActionType.DisabledAction:
      case ActionType.DismissAction:
      case ActionType.SilentBackgroundAction:
      case ActionType.SilentAction:
      case ActionType.KeepOnTop:
        debugPrint(
          'Notification created via notification input: "${notification.body}"',
        );
        // await executeLongTaskInBackground();
        // goToRoute(routeName: "/");
        break;

      case null:
      default:
        break;
    }
  }

  @pragma('vm:entry-point')
  Future<void> onNotificationDisplayedMethod(
      ReceivedNotification notification) async {
    // For background actions, you must hold the execution until the end
    switch (notification.actionType) {
      case ActionType.Default:
      case ActionType.DisabledAction:
      case ActionType.DismissAction:
      case ActionType.SilentBackgroundAction:
      case ActionType.SilentAction:
      case ActionType.KeepOnTop:
        debugPrint(
          'Notification created via notification input: "${notification.body}"',
        );
        // await executeLongTaskInBackground();
        // goToRoute(routeName: "/");
        break;

      case null:
      default:
        break;
    }
  }

  @pragma('vm:entry-point')
  Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // For background actions, you must hold the execution until the end
    switch (receivedAction.actionType) {
      case ActionType.Default:
      case ActionType.DisabledAction:
      case ActionType.DismissAction:
      case ActionType.SilentBackgroundAction:
      case ActionType.SilentAction:
      case ActionType.KeepOnTop:
        debugPrint(
          'Dismiss Notification input: "${receivedAction.body}"',
        );
        // await executeLongTaskInBackground();
        // goToRoute(routeName: "/");
        break;

      case null:
      default:
        break;
    }
  }

  Future<void> resetBadgeCounter() async {
    await awesomeNotifications.resetGlobalBadge();
  }

  Future<void> cancelNotifications() async {
    await awesomeNotifications.cancelAll();
  }

  /// REQUESTING NOTIFICATION PERMISSIONS
  Future<bool> _hasNotificationPermissions({
    required BuildContext context,
    required String notificationChannel,
    required Future<bool> Function() hasAllowedPermissionRational,
  }) async {
    bool isAllowed = await awesomeNotifications.isNotificationAllowed();
    if (isAllowed) return true;

    if (context.mounted) {
      bool accepted = await hasAllowedPermissionRational();
      if (!accepted) return false;

      isAllowed =
          await awesomeNotifications.requestPermissionToSendNotifications(
        channelKey: notificationChannel,
      );
    }

    return isAllowed;
  }

  ///  NOTIFICATION CREATION METHODS
  Future<bool> _createNewNotification({
    required BuildContext context,
    required MobileOptions mobileOptions,
  }) async {
    NotificationChannel channel = mobileOptions.channel;
    String? channelName = channel.channelName;
    if (channelName == null) {
      debugPrint("Channel name required");
      return false;
    }

    String? channelKey = channel.channelKey;
    if (channelKey == null) {
      debugPrint("Channel key required");
      return false;
    }

    Future<bool> Function() hasAllowedPermissionRational =
        mobileOptions.hasAllowedPermissionRational ?? () async => false;

    bool isAllowed = await _hasNotificationPermissions(
      context: context,
      notificationChannel: channelName,
      hasAllowedPermissionRational: hasAllowedPermissionRational,
    );

    if (!isAllowed) {
      debugPrint("Notifications not allowed");
      return false;
    }

    return await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: mobileOptions.notificationId,
        channelKey: channelKey,
        groupKey: channel.channelGroupKey,
        wakeUpScreen: mobileOptions.wakeUpScreen,
        criticalAlert: channel.criticalAlerts ?? false,
        color: channel.defaultColor,
        displayOnBackground: mobileOptions.locked,
        displayOnForeground: mobileOptions.locked,
        autoDismissible: mobileOptions.autoDismissible,
        timeoutAfter: mobileOptions.timeout,
        chronometer: mobileOptions.chronometer,
        actionType: mobileOptions.actionType,
        category: mobileOptions.notificationCategory,
        title: mobileOptions.title,
        body: mobileOptions.message,
        icon: mobileOptions.icon,
        bigPicture: mobileOptions.bigPicture,
        largeIcon: mobileOptions.largeIcon,
        notificationLayout: mobileOptions.notificationLayout,
        payload: mobileOptions.payload,
      ),
      schedule: mobileOptions.schedule,
      actionButtons: mobileOptions.actions +
          [
            NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true,
              autoDismissible: mobileOptions.autoDismissible,
              requireInputText: mobileOptions.requireInputText,
              icon: mobileOptions.icon,
            )
          ],
    );
  }

  @override
  Future<bool> pushNotification({
    required BuildContext context,
    MobileOptions? mobileOptions,
    WebOptions? webOptions,
    DesktopOptions? desktopOptions,
  }) {
    if (mobileOptions == null) {
      throw Exception("Provide mobile options for MobileNotificationService");
    }
    return _createNewNotification(
        context: context, mobileOptions: mobileOptions);
  }
}
*/
