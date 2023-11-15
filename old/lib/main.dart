import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edgermanflex/firebase/auth-service.dart';
import 'package:edgermanflex/forum.dart';
import 'package:edgermanflex/home.dart';
import 'package:edgermanflex/service/service.dart';
import 'package:edgermanflex/updates.dart';
import 'package:edgermanflex/video.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Icons/e_d_g_f__icons_icons.dart';
import 'extra/AppInformation.dart';
import 'extra/Internet.dart';
import 'firebase/auth-data.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  _SetVersion();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize('resource://drawable/logo', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
Future<void> _SetVersion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('Version', '0.9.3');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => MyHomePage(PageN: 0),
            '/update': (BuildContext context) => update(),
          },
          title: 'EDGermanFlex',
          navigatorKey: Get.key,
          color: Color(0xff2b2b2b),
          home: FutureBuilder(
            future: FirstTimeOpened(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == false) {
                return FutureBuilder(
                  future: check(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data == true) {
                      setFTO();
                      return FutureBuilder(
                        future: AppVersion(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.data['Version'] ==
                              snapshot.data['AppV']) {
                            return MyHomePage(
                              PageN: 0,
                            );
                          } else {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text('New App Version'),
                              ),
                              body: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/patterndark.png"),
                                      fit: BoxFit.cover),
                                ),
                                width: 5000,
                                height: 5000,
                                child: Center(
                                  child: Text(
                                    'The App have A new Version. Update the App to use it again',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('No Internet Connection'),
                        ),
                        body: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/patterndark.png"),
                                fit: BoxFit.cover),
                          ),
                          width: 5000,
                          height: 5000,
                          child: Center(
                            child: Text(
                              'For using the App the First time you need a Internet Connection',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              } else {
                // true
                return FutureBuilder(
                  future: AppVersion(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data['Version'] == snapshot.data['AppV']) {
                      return MyHomePage(
                        PageN: 0,
                      );
                    } else {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('New App Version'),
                        ),
                        body: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/patterndark.png"),
                                fit: BoxFit.cover),
                          ),
                          width: 5000,
                          height: 5000,
                          child: Center(
                            child: Text(
                              'The App have A new Version. Update the App to use it again',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          )));
}

class MyHomePage extends StatefulWidget {
  late int PageN;
  MyHomePage({Key? key, required this.PageN}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState(PageN);
}

class MyHomePageState extends State<MyHomePage> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  int PageN;
  MyHomePageState(this.PageN);

  @override
  void initState() {
    super.initState();
    setPage(PageN);
    firebaseonMessage();
    firebaseOpenedApp();
    WidgetsBinding.instance!.addPostFrameCallback((_) => OfflineMessage());
    WidgetsBinding.instance!.addPostFrameCallback((_) => ShowWelcomeMessage());
    this.initDynamicLinks();
  }

  void setPage(int PageN) {
    controller.jumpToTab(PageN);
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink;

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.path == '/home') {
        Navigator.pushNamed(context, '/home');
        controller.jumpToTab(0);
      } else if (deepLink.path == '/video') {
        Navigator.pushNamed(context, '/home');
        controller.jumpToTab(1);
      } else if (deepLink.path == '/forum') {
        Navigator.pushNamed(context, '/home');
        controller.jumpToTab(2);
      } else if (deepLink.path == '/profile') {
        Navigator.pushNamed(context, '/home');
        controller.jumpToTab(3);
      } else {
        Navigator.pushNamed(context, deepLink.path);
      }
    }
  }

  void firebaseonMessage() {
    print('onmessage start');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.notification!.title.toString())));
    });
  }

  void firebaseOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  void OfflineMessage() {
    final snackBar = SnackBar(
      content: Text(
        'Offline',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff2b2b2b),
      duration: Duration(days: 356),
    );

    check().then((value) => {
          if (value == false)
            {ScaffoldMessenger.of(context).showSnackBar(snackBar)}
        });
  }

  void ShowWelcomeMessage() {
    if (Auth_isloggedin()) {
      Auth_Username().then((value) => Get.snackbar(
            value,
            'Welcome Back',
            barBlur: 45,
            isDismissible: false,
            duration: Duration(seconds: 4),
            snackPosition: SnackPosition.TOP,
          ));
    } else {
      Auth_Username().then((value) => Get.snackbar(
            'Welcome',
            'New User',
            barBlur: 45,
            isDismissible: false,
            duration: Duration(seconds: 4),
            snackPosition: SnackPosition.TOP,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        Home(),
        video(),
        forum(),
        serviceWidget(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(
            EDGF_Icons.home,
            size: 32,
          ),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.systemPink,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(EDGF_Icons.video),
          title: ("Videos"),
          activeColorPrimary: CupertinoColors.activeGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(EDGF_Icons.forum),
          title: ("Forum"),
          activeColorPrimary: CupertinoColors.systemTeal,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(EDGF_Icons.profile),
          title: ("Profile"),
          activeColorPrimary: Colors.orange,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Color(0xff2b2b2b),
      ),
      body: PersistentTabView(
        context,
        screens: _buildScreens(),
        controller: controller,
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        backgroundColor: Color(0xff2b2b2b),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 650),
          curve: Curves.decelerate,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.easeInOutQuint,
          duration: Duration(milliseconds: 550),
        ),
        navBarStyle: NavBarStyle.style1,
        hideNavigationBarWhenKeyboardShows: true,
      ),
    );
  }
}
