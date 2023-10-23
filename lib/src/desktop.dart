import 'package:eazy_notification/eazy_notification.dart';
import 'package:flutter/material.dart';
export 'package:local_notifier/local_notifier.dart';

class DesktopNotificationService extends EazyNotificationService {
  final LocalNotifier notifier = LocalNotifier.instance;

  final String appName;

  DesktopNotificationService({required this.appName});

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await notifier.setup(
      appName: appName,
      // The parameter shortcutPolicy only works on Windows
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );

    debugPrint("Desktop notifications initiated");
  }

  Future<bool> _createNotification({
    required DesktopOptions desktopOptions,
  }) async {
    LocalNotification notification = LocalNotification(
      identifier: desktopOptions.notificationId,
      title: desktopOptions.title,
      subtitle: desktopOptions.subTitle,
      silent: desktopOptions.silent,
      body: desktopOptions.message,
    );

    //Listeners
    notification.onShow = desktopOptions.onShow?.call(notification);

    notification.onClose =
        (closeReason) => desktopOptions.onClose?.call(closeReason);

    //OnClick
    notification.onClick = desktopOptions.onClick?.call(notification);

    notification.onClickAction = (i) => desktopOptions.onClickAction?.call(i);

    //show
    await notification.show();

    return true;
  }

  @override
  Future<bool> pushNotification({
    required BuildContext context,
    MobileOptions? mobileOptions,
    WebOptions? webOptions,
    DesktopOptions? desktopOptions,
  }) {
    if (desktopOptions == null) {
      throw Exception("Provide desktop options for DesktopNotificationService");
    }
    return _createNotification(desktopOptions: desktopOptions);
  }
}
