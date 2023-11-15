import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edgermanflex/extra/unique.dart';

Future<void> notification(var title, var body) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Messaging,
        displayOnForeground: true,
        displayOnBackground: true,
      )
  );
}