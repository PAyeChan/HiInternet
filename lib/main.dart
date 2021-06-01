import 'package:flutter/material.dart';
import 'package:hiinternet/providers/service_history_ticket.dart';
import 'package:hiinternet/screens/account_screen/account_screen.dart';
import 'package:hiinternet/screens/home_screen/home_screen.dart';
import 'package:hiinternet/screens/notification_screen/notification_screen.dart';
import 'package:hiinternet/screens/payment_screen/payment_screen.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_screen.dart';
import 'package:hiinternet/screens/service_issue_screen/service_issue_screen.dart';
import 'package:hiinternet/screens/tabs_screen/tab_screen.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  @override
  Widget build(BuildContext context) {
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
