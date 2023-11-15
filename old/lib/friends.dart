import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/firebase/auth-data.dart';
import 'package:edgermanflex/firebase/checkFriends.dart';
import 'package:edgermanflex/service/serviceFriend.dart';
import 'package:edgermanflex/widgets/UserProfile.dart';
import 'package:edgermanflex/widgets/chatroom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class friend extends StatefulWidget{
  @override
  _friend createState() => _friend();
}

class _friend extends State<friend>{

  @override
  Widget build(BuildContext context) {

    if (Auth_isloggedin()) {
      double deviceWidth = MediaQuery.of(context).size.width;
      double deviceHeight = MediaQuery.of(context).size.height;

      var user = FirebaseAuth.instance.currentUser!.uid;

      return Scaffold(
          body:
            Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/patterndark.png'),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: deviceHeight * 0.8,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('User').doc(user).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {

                            if (!snapshot.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),

                                ],
                              );
                            }  // if

                            if (snapshot.hasError) {
                              return Container(
                                  child: Text('No Posts Found')
                              );
                            }

                            if (snapshot.hasData) {

                              return ListView(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                children: [
                                  for (var i in snapshot.data['friends'])
                                    Slidable(
                                      child: GestureDetector(
                                        onTap: () {
                                          FriendCheck(i).then(
                                                  (value) => Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => Chatroom(
                                                    SUID: user,
                                                    EUID: i,
                                                    RoomID: value,
                                                  )
                                              )
                                              )
                                          );
                                        },
                                        onLongPress: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => UserProfileWidget(UserID: i,)
                                            )
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(25),
                                                child: Container(
                                                  width: deviceWidth * 0.95,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                  ),
                                                  child: ListTile(
                                                    leading: FutureBuilder(
                                                      future: AuthID_Userpfp(i),
                                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot)
                                                      {
                                                        return new ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: new CachedNetworkImage(
                                                            imageUrl: snapshot.data.toString(),
                                                            height: 50,
                                                            width: 50,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      },

                                                    ),
                                                    title: FutureBuilder(
                                                      future: AuthID_Username(i),
                                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot)
                                                      {
                                                        return Text(snapshot.data.toString(),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    subtitle: FutureBuilder(
                                                      future: AuthID_Status(i),
                                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot)
                                                      {
                                                        return Text(snapshot.data.toString(),
                                                          style: TextStyle(
                                                              fontStyle: FontStyle.italic
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              );
                            }
                            return Text('BAD');
                          },
                        ),
                      )

                    ],
                  ),
                )

      );
    }

    else {
      return serviceFriendWidget();
    }

  }
}