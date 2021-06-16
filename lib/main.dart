import 'package:flutter/material.dart';
import 'package:hiinternet/providers/service_history_ticket.dart';
import 'package:hiinternet/screens/tabs_screen/tab_screen.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hiinternet/service/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:hiinternet/data/notification_model.dart';
import 'package:hiinternet/data/database_util.dart';


import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseUtil().InitDatabase();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: ServiceHistoryTicket()),
    ],
    child: new MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff004785),
          primarySwatch: Colors.blue,
          primaryColorDark: Color(0xFF181F3C),
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
                button: TextStyle(color: Colors.white),
              )),
      home: MyApp(),
      routes: {/*
        HomeScreen.routeName: (ctx) => HomeScreen("ENG"),
        PaymentScreen.routeName: (ctx) => PaymentScreen(),
        NotificationScreen.routeName: (ctx) => NotificationScreen(),
        AccountScreen.routeName: (ctx) => AccountScreen(),
        ServiceHistoryScreen.routeName: (ctx) => ServiceHistoryScreen(),
        ServiceIssueScreen.routeName: (ctx) => ServiceIssueScreen(),*/
        TabScreen.routeName: (ctx) => TabScreen(),
      },
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _initialized = false;
  bool _error = false;

  FirebaseMessaging _messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidNotificationChannel channel;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      //initializeFirebaseMsg();

      channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void initializeFirebaseMsg() async {
    _messaging = FirebaseMessaging.instance;

    await FirebaseMessaging.instance.subscribeToTopic('hi');

    _messaging.getToken().then((token) {

    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('notification.body' + message.notification.body);
        print('notification.body' + message.notification.title);
      }

      if (message.data != null) {
        print('Message also contained a data: ' + jsonEncode(message.data));
      }

      NotiModel notiModel = NotiModel.fromJson(message.data);

      if (notiModel != null) {
        DatabaseUtil().insertNotification(notiModel);

        flutterLocalNotificationsPlugin.show(
            notiModel.hashCode,
            notiModel.title,
            notiModel.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            )
        );
      }

    });
  }

  @override
  void initState() {
    initializeFlutterFire();
    NotificationService().handleApplicationWasLaunchedFromNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_initialized) {
      initializeFirebaseMsg();
    }

    return Center(
      child: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new AfterSplash(),
        title: Text(
          'Loading...',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset(
          'assets/images/floating_icon.png',
        ),
        photoSize: 50,
        backgroundColor: Theme.of(context).primaryColorDark,
        loaderColor: Colors.red,
      ),
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabScreen();
  }
}
