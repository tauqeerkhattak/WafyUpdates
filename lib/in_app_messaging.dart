import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

class InAppMessaging {
  static final InAppMessaging _instance = InAppMessaging._();
  FirebaseMessaging notificationMessage = FirebaseMessaging();
  bool _initialized = false;

  factory InAppMessaging () => _instance;
  InAppMessaging._();

  // ignore: missing_return
  Future <void> init (BuildContext context) {
    if(!_initialized) {
      notificationMessage.requestNotificationPermissions();
      notificationMessage.configure();
      print(notificationMessage.getToken());
      _initialized = true;
    }
  }

  Future <Map<String,dynamic>> sendNotificationMessage (String title,String body) async {
    await notificationMessage.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAqChHq5Y:APA91bEl89atFquWh5IDiS2X9PE5orQAWe5pDErqyffwOLkvAuh-L4mVy1efnlzfXNyQqUKr4ImrY5AWqAoLvuS40Hw8IsNhie0k5pjCKp-_fTkNBR5yvVM_SRvY18UUlVk1vuZkuJ0O',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic> {
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic> {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': await notificationMessage.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer = Completer <Map<String, dynamic>>();
    notificationMessage.configure(
      onMessage: (Map<String,dynamic> message) async {
        completer.complete(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map <String, dynamic> message) async {
        completer.complete(message);
      },
      onResume: (Map <String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print(data.toString());
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print(notification.toString());
    }

    // Or do other work.
  }
}