import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'Icons/e_d_g_f__icons_icons.dart';
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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

  forum() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xff2b2b2b),
      ),
      body: const Text('Text'),
    );
  }

  serviceWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xff2b2b2b),
      ),
      body: const Text('Text'),
    );
  }
}


