import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morgan/profile-page/profile_Comment.dart';
import 'package:morgan/profile-page/profile_Forum.dart';
import 'package:morgan/profile-page/profile_Friends+.dart';
import 'package:morgan/settings.dart';
import 'package:morgan/updates.dart';
import 'package:morgan/utils/Authentication.dart';
import 'package:shimmer/shimmer.dart';

import 'firebase/auth-data.dart';
import 'firebase/auth-service.dart';
import 'main.dart';

class profileWidget extends StatefulWidget {
  @override
  _profileWidget createState() => _profileWidget();
}

class _profileWidget extends State<profileWidget>
    with TickerProviderStateMixin {
  Future<void> handleClick(int item) async {
    switch (item) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => update()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => settings()));
        break;
      case 2:
        await Authentication.signOut(context: context);
        Get.to(MyHomePage(PageN: 3,));
        break;
    }
  }

  final TextEditingController textController = TextEditingController();
  late AnimationController Namecontroller;
  late AnimationController Statuscontroller;
  late AnimationController UIDcontroller;

  @override
  void initState() {
    Namecontroller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    Statuscontroller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    UIDcontroller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    final user = FirebaseAuth.instance.currentUser!;

    final Animation<double> NameoffsetAnimation = Tween(begin: 0.0, end: 2.0).chain(CurveTween(curve: Curves.elasticIn)).animate(Namecontroller)..addStatusListener((status) {if (status == AnimationStatus.completed) {
              Namecontroller.reverse();
            }});
    final Animation<double> StatusoffsetAnimation = Tween(begin: 0.0, end: 2.0).chain(CurveTween(curve: Curves.elasticIn)).animate(Statuscontroller)..addStatusListener((status) {if (status == AnimationStatus.completed) {Statuscontroller.reverse();}});
    final Animation<double> UIDoffsetAnimation = Tween(begin: 0.0, end: 2.0).chain(CurveTween(curve: Curves.elasticIn)).animate(UIDcontroller)..addStatusListener((status) {if (status == AnimationStatus.completed) {UIDcontroller.reverse();}});

    final Pcontroller = PageController(
      initialPage: 0,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/patterndark.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Container(
                width: deviceWidth,
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(70, 70, 70, 30)),
                child: Row(
                  // 1st part row
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.fromLTRB(5, 15, 0, 13),
                        width: deviceWidth * 0.33,
                        alignment: Alignment.topCenter,
                        child: FutureBuilder(
                          future: Auth_Userpfp(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data.toString(),
                                height: deviceWidth * 0.28,
                                width: deviceWidth * 0.28,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        )),
                    Container(
                      width: deviceWidth * 0.53,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                              animation: NameoffsetAnimation,
                              builder: (buildContext, child) {
                                return Container(
                                    padding: EdgeInsets.only(
                                        left: NameoffsetAnimation.value + 2.0,
                                        right: 2.0 - NameoffsetAnimation.value),
                                    child: FutureBuilder(
                                      future: Auth_Check_Premium(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.data['premium'] == false) {
                                          return GestureDetector(
                                            onTap: () {
                                              Namecontroller.forward(from: 0.0);
                                              Clipboard.setData(ClipboardData(
                                                  text: snapshot
                                                      .data['username']
                                                      .toString()));
                                            },
                                            child: Text(
                                              snapshot.data['username']
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 24),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              Namecontroller.forward(from: 0.0);
                                              Clipboard.setData(ClipboardData(
                                                  text: snapshot
                                                      .data['username']
                                                      .toString()));
                                            },
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.orange,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                snapshot.data['username']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 24),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ));
                              }),
                          AnimatedBuilder(
                              animation: StatusoffsetAnimation,
                              builder: (buildContext, child) {
                                return Container(
                                    padding: EdgeInsets.only(
                                        left: StatusoffsetAnimation.value + 2.0,
                                        right:
                                            2.0 - StatusoffsetAnimation.value),
                                    child: FutureBuilder(
                                      future: Auth_Status(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        return GestureDetector(
                                          onTap: () {
                                            Statuscontroller.forward(from: 0.0);
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    snapshot.data.toString()));
                                          },
                                          child: Text(
                                            snapshot.data.toString(),
                                            style: const TextStyle(
                                                color: Colors.deepOrangeAccent,
                                                fontSize: 20),
                                          ),
                                        );
                                      },
                                    ));
                              }),
                          AnimatedBuilder(
                              animation: UIDoffsetAnimation,
                              builder: (buildContext, child) {
                                return Container(
                                    padding: EdgeInsets.only(
                                        left: UIDoffsetAnimation.value + 2.0,
                                        right: 2.0 - UIDoffsetAnimation.value),
                                    child: FutureBuilder(
                                      future: Auth_UserUID(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        return GestureDetector(
                                          onTap: () {
                                            UIDcontroller.forward(from: 0.0);
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    snapshot.data.toString()));
                                          },
                                          child: Text(
                                            'UID: ' + snapshot.data.toString(),
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 12),
                                          ),
                                        );
                                      },
                                    ));
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: PopupMenuButton<int>(
                        onSelected: (item) => handleClick(item),
                        itemBuilder: (context) => [
                          const PopupMenuItem<int>(value: 0, child: Text('Updates')),
                          const PopupMenuItem<int>(value: 1, child: Text('Settings')),
                          const PopupMenuItem<int>(value: 2, child: Text('Logout')),
                        ],
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: Container(
                child: PageView(
                  controller: Pcontroller,
                  children: [
                    profile_Friendsplus(
                      UserID: user.uid,
                      UserID2: user.uid,
                    ),
                    profile_Forum(UserID: user.uid),
                    profile_Comment(
                      UserID: user.uid,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
