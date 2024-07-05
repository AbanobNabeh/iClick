import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:iclick/config/services/contect_utility.dart';
import 'package:iclick/features/chat/presentation/pages/chatscreen.dart';
import 'package:iclick/features/home/presentation/pages/postview.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';
import 'package:iclick/features/reels/presentation/pages/rellview.dart';

class APInotification {
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  static void initNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          Map<String, dynamic> data = jsonDecode(response.payload!);
          handlepaths(data['type'], data['link']);
        }
      },
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final fcmToken = await messaging.getToken();
    print("FCM Token: $fcmToken");
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(flutterLocalNotificationsPlugin, message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handlepaths(message.data['type'], message.data['link']);
    });
  }

  static Future<http.Response> sendnotifiuser(
      {required String to,
      required String title,
      required String body,
      String? type,
      String? link}) async {
    final String serverKey = await getAccessToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey'
    };
    Map nottifiy = {
      "message": {
        "token": to,
        "notification": {"title": title, "body": body},
        "data": {"type": type, "link": link}
      },
    };
    return await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/iclick-16b0b/messages:send"),
        body: jsonEncode(nottifiy),
        headers: headers);
  }

  static void subscribeToTopic(String topic) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic(topic);
    print("Subbe Success =${topic}");
  }

  static void unsubscribeToTopic(String topic) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.unsubscribeFromTopic(topic);
  }

  static Future<http.Response> sendnotifitopic(
      {required String topic,
      required String title,
      required String body,
      String? type,
      String? link}) async {
    final String serverKey = await getAccessToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey'
    };
    Map nottifiy = {
      "message": {
        "topic": topic,
        "notification": {"title": title, "body": body},
        "data": {"type": type, "link": link}
      },
    };
    return await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/iclick-16b0b/messages:send"),
        body: jsonEncode(nottifiy),
        headers: headers);
  }

  static void handlepaths(String type, link) {
    switch (type) {
      case "post":
        ContextUtility.navigator?.push(
          MaterialPageRoute(builder: (_) => PostView(int.parse(link))),
        );
      case "reel":
        ContextUtility.navigator?.push(
          MaterialPageRoute(builder: (_) => ReelViewScreen(int.parse(link))),
        );
      case "user":
        ContextUtility.navigator?.push(
          MaterialPageRoute(builder: (_) => ProfileUserScreen(int.parse(link))),
        );
      case "chat":
        ContextUtility.navigator?.push(
          MaterialPageRoute(builder: (_) => ChatScreen(int.parse(link))),
        );
    }
  }

  static void _showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          ),
        ),
        payload: jsonEncode(message.data), // Pass the data as payload
      );
    }
  }
}
