import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:morgan/service/service.dart';
import 'extra/Internet.dart';
import 'firebase/auth-data.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'Icons/e_d_g_f__icons_icons.dart';
import 'forum.dart';
import 'home.dart';
import 'video.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ED German Flex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage( PageN: 0,),
    );
  }
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
    const snackBar = SnackBar(
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
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      ));
    } else {
      Auth_Username().then((value) => Get.snackbar(
        'Welcome',
        'New User',
        barBlur: 45,
        isDismissible: false,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      ));
    }
  }



  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
        const Home(),
        video(),
        forum(),
        serviceWidget(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(
            EDGF_Icons.home,
            size: 32,
          ),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.systemPink,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(EDGF_Icons.video),
          title: ("Videos"),
          activeColorPrimary: CupertinoColors.activeGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(EDGF_Icons.forum),
          title: ("Forum"),
          activeColorPrimary: CupertinoColors.systemTeal,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(EDGF_Icons.profile),
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
        backgroundColor: const Color(0xff2b2b2b),
      ),
      body: PersistentTabView(
        context,
        screens: buildScreens(),
        items: navBarsItems(),
        handleAndroidBackButtonPress: true,
        backgroundColor: const Color(0xff2b2b2b),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 650),
          curve: Curves.decelerate,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
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




