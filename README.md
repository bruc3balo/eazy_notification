# Eazy Notifications
This package is just a bridge to start of with notifications by using other packages to provide notifications on each platform


### Customize your notification based on platform

**Note**: The necessary initializations have to be done for each platform as instructed by each of these platforms

## Create and initialize the notification service
The package uses [mplatform](https://pub.dev/packages/mplatform) to determine which is the current platform

1) Create the service
```dart
  final EazyNotificationService _service = switch (Mplatform.current) {
    Mplatform.ios => MobileNotificationService(
        channels: NotificationChannelEnum.values.map((e) => e.channel).toList(),
        channelGroups:
            NotificationChannelEnum.values.map((e) => e.channelGroup).toList(),
      ),
    Mplatform.android => MobileNotificationService(
        channels: NotificationChannelEnum.values.map((e) => e.channel).toList(),
        channelGroups:
            NotificationChannelEnum.values.map((e) => e.channelGroup).toList(),
      ),
    Mplatform.web => WebNotificationService(),
    Mplatform.fuchsia => WebNotificationService(),
    Mplatform.linux => DesktopNotificationService(appName: AppConfig.appName),
    Mplatform.windows => DesktopNotificationService(appName: AppConfig.appName),
    Mplatform.macos => DesktopNotificationService(appName: AppConfig.appName),
  };
```



2) Initialize the service in main
```dart
 await _service.init();
```

3) Show notification
```dart
bool sent = await _service.pushNotification(
          context: context,
          desktopOptions: desktopOptions,
          mobileOptions: mobileOptions,
          webOptions: webOptions,
        );
```

## Android & IOS
The mobile platform used the package [Awesome Notifications](https://pub.dev/packages/awesome_notifications)

```dart

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

```

Use the **hasAllowedPermissionRational()** function to show the user that you are requesting for notifications and return the result to the future
```dart
  Future<bool> hasAllowedPermissionRational(BuildContext context) async {
  bool allowed = false;
  await showGenericDialog(
    context: context,
    title: 'Allow notifications',
    brief: 'We would like to notify you of updates',
    confirmButtonText: 'Allow',
    onConfirm: (c) async {
      Navigator.of(context).pop();
      allowed = true;
    },
    denyButtonText: 'Maybe Later',
    onDeny: (c) async {
      Navigator.of(context).pop();
      allowed = false;
    },
  );
  return allowed;
}

## Windows, Linux & MacOs
The desktop platform uses the package [Local Notifier](https://pub.dev/packages/local_notifier)
```dart
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

```

### Web
The web platform used the package [Elegant Notifications](https://pub.dev/packages/elegant_notification)

```dart

class WebOptions {
  final Widget? title;
  final Widget description;
  final Widget icon;
  final Function() onDismiss;
  final ProgressIndicatorBar? progressIndicator;
  final NotificationAction? notificationAction;
  final NotificationCloseButton? notificationCloseButton;
  final NotificationStyle? notificationStyle;
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
    this.autoDismiss = true,
  });
}

```