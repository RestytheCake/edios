import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edgermanflex/extra/Internet.dart';
import 'package:edgermanflex/home.dart';
import 'package:edgermanflex/notification/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'extra/AppInformation.dart';
import 'firebase/auth-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _SetVersion();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getToken().then((value) => print(value));
  AwesomeNotifications().initialize('resource://drawable/muffinick', [NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      importance: NotificationImportance.High,
      channelShowBadge: true,
      channelDescription: 'Notification channel for basic tests',
      defaultColor: Color(0xFFEE4E4E),
      ledColor: Colors.white
  )]);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
}

Future<void> _SetVersion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('Version', '0.8.7');
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          home: FutureBuilder(
            future: FirstTimeOpened(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == false) {
                return FutureBuilder(
                  future: check(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data == true) {
                      setFTO();
                      return FutureBuilder(
                        future: AppVersion(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                          if(snapshot.data['Version'] == snapshot.data['AppV']) {
                            return MyHomePage();
                          }

                          else {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text('New App Version'),
                              ),
                              body: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/patterndark.png"),
                                      fit: BoxFit.cover
                                  ),
                                ),
                                width: 5000,
                                height: 5000,
                                child: Center(
                                  child: Text('The App have A new Version. Update the App fto use it again',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                        },
                      );
                    }
                    else {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('No Internet Connection'),
                        ),
                        body: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/patterndark.png"),
                                fit: BoxFit.cover
                            ),
                          ),
                          width: 5000,
                          height: 5000,
                          child: Center(
                            child: Text('For using the App the First time you need a Internet Connection',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },

                );
              }

              else { // true
                return FutureBuilder(
                  future: AppVersion(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                    if(snapshot.data['Version'] == snapshot.data['AppV']) {
                      return MyHomePage();
                    }

                    else {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('New App Version'),
                        ),
                        body: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/patterndark.png"),
                                fit: BoxFit.cover
                            ),
                          ),
                          width: 5000,
                          height: 5000,
                          child: Center(
                            child: Text('The App have A new Version. Update the App fto use it again',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                  },
                );
              }
            },
          )
      )
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    firebaseonMessage();
    firebaseOpenedApp();
  }
  void firebaseonMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var title = message.notification!.title;
      var body = message.notification!.body;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title!)));
      notification(title, body);

    }
    );
  }
  void firebaseOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {

    }
    );
  }


  @override
  Widget build(BuildContext context) {

    return Home();
  }
}