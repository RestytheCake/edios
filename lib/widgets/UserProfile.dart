import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Icons/e_d_g_f__icons_icons.dart';
import '../firebase/auth-data.dart';
import '../profile-page/profile_Comment.dart';
import '../profile-page/profile_Forum.dart';
import '../profile-page/profile_Friends.dart';

class UserProfileWidget extends StatefulWidget {
  String UserID;
  UserProfileWidget({required this.UserID});

  @override
  _UserProfileWidget createState() => _UserProfileWidget(UserID);
}

class _UserProfileWidget extends State<UserProfileWidget>
    with SingleTickerProviderStateMixin {
  String UserID;
  _UserProfileWidget(this.UserID);

  @override
  void init() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    final controller = PageController(
      initialPage: 0,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2b2b2b),
        toolbarHeight: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/patterndark.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          //ALL
          children: <Widget>[
            Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(70, 70, 70, 30)),
                child: Row(
                  // 1st part row
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(5, 15, 0, 13),
                        width: deviceWidth * 0.33,
                        alignment: Alignment.topCenter,
                        child: FutureBuilder(
                          future: AuthID_Userpfp(UserID),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: FutureBuilder(
                                future: AuthID_Username(UserID),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 24),
                                  );
                                },
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: FutureBuilder(
                              future: AuthID_Status(UserID),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 18),
                                );
                              },
                            ),
                          ),
                          Container(
                              child: FutureBuilder(
                            future: Auth_UserUID(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return Text(
                                'UID: ' + snapshot.data.toString(),
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 12),
                              );
                            },
                          )),
                        ],
                      ),
                    ),
                  ],
                )),

            Expanded(
              child: Container(
                child: PageView(
                  controller: controller,
                  children: [
                    profile_Friends(UserID: UserID),
                    profile_Forum(UserID: UserID),
                    profile_Comment(UserID: UserID),
                  ],
                ),
              ),
            ), // Own Posts
          ],
        ),
      ),
      floatingActionButton: FlowMenu(),
    );
  }
}

class FlowMenu extends StatefulWidget {
  const FlowMenu({Key? key}) : super(key: key);
  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastTapped = Icons.menu;
  final List<IconData> menuItems = <IconData>[
    EDGF_Icons.profile,
    EDGF_Icons.chat,
    Icons.menu,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu) {
      setState(() => lastTapped = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter =
        MediaQuery.of(context).size.width / menuItems.length * 0.5;
    return RawMaterialButton(
      fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
      splashColor: Colors.amber[100],
      shape: const CircleBorder(),
      constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
      onPressed: () {
        _updateMenu(icon);
        menuAnimation.status == AnimationStatus.completed
            ? menuAnimation.reverse()
            : menuAnimation.forward();
      },
      child: Icon(
        icon,
        color: Colors.white,
        size: 35.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomRight,
      child: Flow(
        delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
        children: menuItems
            .map<Widget>((IconData icon) => flowMenuItem(icon))
            .toList(),
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx * menuAnimation.value,
          dx * menuAnimation.value,
          0,
        ),
      );
    }
  }
}
