// import 'dart:developer';
// import 'dart:io';
// import 'dart:math' hide log;
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:agri/core/configs/colors_manager.dart';
// import 'package:agri/core/infrastructure/di.dart';
// import 'package:agri/core/resources/route_manager.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:agri/firebase_options.dart';

// const _channelGroupKey = 'default_notification_channel_id';
// const _channelKey = 'default_notification_channel_id';
// const _channelName = 'default_notification_channel_id';
// const _channelDescription = 'Notification channel';

// // @lazySingleton
// class NotificationsService {
//   late final AwesomeNotifications awesomeNotifications;

//   static NotificationsService? instance;

//   factory NotificationsService() {
//     if (instance == null) {
//       instance = NotificationsService._();
//       instance!.awesomeNotifications = AwesomeNotifications();
//     }
//     return instance!;
//   }

//   NotificationsService._();

//   String? chatIDToOpen;

//   // @PostConstruct(preResolve: true)
//   Future<void> init() async {
//     await _requestNotificationPermission();
//     await _initializeNotifications();
//     await _initFirebaseMessaging();
//   }

//   Future<void> initbackground() async {
//     await _requestNotificationPermission();
//     await _initializeNotifications();
//   }

//   Future<void> _requestNotificationPermission() async {
//     await awesomeNotifications.isNotificationAllowed().then((isAllowed) async {
//       if (!isAllowed) {
//         await awesomeNotifications.requestPermissionToSendNotifications();
//       }
//     });
//   }

//   Future<void> _initializeNotifications() async {
//     await awesomeNotifications.initialize(
//         null,
//         [
//           NotificationChannel(
//             channelGroupKey: _channelGroupKey,
//             channelKey: _channelKey,
//             channelName: _channelName,
//             channelDescription: _channelDescription,
//             channelShowBadge: true,
//             enableLights: true,
//             enableVibration: true,
//             playSound: true,
//             importance: NotificationImportance.High,
//             defaultColor: ColorsManager.primary,
//             ledColor: ColorsManager.primary,
//           ),
//         ],
//         channelGroups: [
//           NotificationChannelGroup(
//             channelGroupKey: _channelGroupKey,
//             channelGroupName: _channelName,
//           ),
//         ],
//         debug: true);
//     await awesomeNotifications.setListeners(
//       onActionReceivedMethod: NotificationListeners.onActionReceivedMethod,
//       onNotificationCreatedMethod:
//           NotificationListeners.onNotificationCreatedMethod,
//       onNotificationDisplayedMethod:
//           NotificationListeners.onNotificationDisplayedMethod,
//       onDismissActionReceivedMethod:
//           NotificationListeners.onDismissActionReceivedMethod,
//     );
//   }

//   Future<void> _initFirebaseMessaging() async {
//     final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//     await firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: false,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//     await firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log('Got a message whilst in the foreground!');
//       log('Message data: ${message.data}');
//       if (message.notification != null) {
//         log('Message also contained a notification: ${message.notification}');
//       }
//       if (!Platform.isIOS) {
//         createNotification(
//           id: Random().nextInt(1000),
//           title: message.notification?.title ?? '',
//           body: message.notification?.body ?? '',
//           groupKey: _channelGroupKey,
//           payload: message.data,
//         );
//       }
//     });
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       log('Firebase Messaging Token Refreshed: $newToken');
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       log('onMessageOpenedApp');
//       chatIDToOpen = _getChatIDFromData(message.data);
//       handleOpeningNotification();
//     });
//     FirebaseMessaging.onBackgroundMessage(
//         NotificationListeners.firebaseMessagingBackgroundHandler);
//     final messageToOpen = await getInitialMessage();
//     if (messageToOpen != null) {
//       chatIDToOpen = _getChatIDFromData(messageToOpen.data);
//     }
//     log((await firebaseMessaging.getToken()) ?? '');
//   }

//   Future<RemoteMessage?> getInitialMessage() async {
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     log('hello getInitialMessage , ${initialMessage?.data}');
//     return await FirebaseMessaging.instance.getInitialMessage();
//   }

//   Future<void> createNotification({
//     required int id,
//     required String title,
//     required String body,
//     required String groupKey,
//     required Map<String, dynamic>? payload,
//     NotificationSchedule? schedule,
//   }) async {
//     log(body.toString());
//     // final Map<String, String>? data = payload?.map(
//     //   (key, value) => MapEntry(
//     //     key,
//     //     value.toString(),
//     //   ),
//     // );
//     // final chatID = _getChatIDFromData(data!);
//     await awesomeNotifications.createNotification(
//         content: NotificationContent(
//           id: id,
//           // payload: {'chatID': chatID},
//           channelKey: _channelKey,
//           groupKey: groupKey,
//           title: title,
//           body: body,
//           wakeUpScreen: true,
//           color: ColorsManager.primary,
//           category: NotificationCategory.Service,
//           notificationLayout: NotificationLayout.Default,
//         ),
//         schedule: schedule);
//   }

//   Future<void> createRingtoneNotification({
//     required int id,
//     required String title,
//     required String body,
//     required String groupKey,
//     required Map<String, dynamic>? payload,
//     NotificationSchedule? schedule,
//   }) async {
//     log(body.toString());
//     // final Map<String, String>? data = payload?.map(
//     //   (key, value) => MapEntry(
//     //     key,
//     //     value.toString(),
//     //   ),
//     // );
//     // final chatID = _getChatIDFromData(data!);
//     await awesomeNotifications.createNotification(
//         content: NotificationContent(
//           id: id,
//           // payload: {'chatID': chatID},
//           channelKey: _channelKey,
//           groupKey: groupKey,
//           title: title,
//           body: body,
//           wakeUpScreen: true,
//           color: ColorsManager.primary,
//           category: NotificationCategory.Call,
//           criticalAlert: true,
//           locked: true,
//           notificationLayout: NotificationLayout.Default,
//         ),
//         schedule: schedule);
//   }

//   Future<void> cancelNotifications() async {
//     // await awesomeNotifications.cancelAllSchedules();
//     await awesomeNotifications.dismissAllNotifications();
//   }

//   static void handleOpeningNotification() {
//     // ProviderScope.containerOf(RouteManager.navigatorKey.currentContext!)
//     //     .read(chatRoomNotifierProvider.notifier)
//     //     .reset();
//     Future.delayed(Durations.long4, () {
//       RouteManager.canPop(context: null)
//           ? RouteManager.replace(RouteManager.notification, arguments: true)
//           : RouteManager.goTo(RouteManager.notification, arguments: true);
//     });
//   }
// }

// class NotificationListeners {
//   /// Use this method to detect when a new notification or a schedule is created
//   @pragma('vm:entry-point')
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {}

//   /// Use this method to detect every time that a new notification is displayed
//   @pragma('vm:entry-point')
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {}

//   /// Use this method to detect if the user dismissed a notification
//   @pragma('vm:entry-point')
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {}

//   /// Use this method to detect when the user taps on a notification or action button
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // Your code goes here
//     // Navigate into pages, avoiding to open the notification details page over another details page already opened
//     log('ReceivedAction onActionReceived :${receivedAction.toMap()}');
//     di<NotificationsService>().chatIDToOpen = receivedAction.payload!['chatID'];
//     log('hello awesome notifications');
//     if (!Platform.isIOS) {
//       NotificationsService.handleOpeningNotification();
//     }
//   }

//   @pragma('vm:entry-point')
//   static Future<void> firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     log('Handling a background message ${message.data}');
//     final chatID = _getChatIDFromData(message.data);
//     log('$chatID  bg handler');
//     di<NotificationsService>().chatIDToOpen = chatID;
//     // handleOpeningNotification();
//   }
// }

// String _getChatIDFromData(Map<String, dynamic> data) {
//   // final chatID = data['parameters']
//   //     .toString()
//   //     .split(',')
//   //     .firstWhere(
//   //       (element) {
//   //         return element.contains('redirection_url');
//   //       },
//   //     )
//   //     .split('chatId=')
//   //     .last
//   //     .replaceAll('"', '');
//   return '';
// }
