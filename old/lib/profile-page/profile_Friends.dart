import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/Icons/e_d_g_f__icons_icons.dart';
import 'package:edgermanflex/firebase/auth-data.dart';
import 'package:edgermanflex/widgets/UserProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class profile_Friends extends StatelessWidget {
  String UserID;

  profile_Friends({required this.UserID});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: deviceWidth * 0.95,
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                  leading: Icon(
                    EDGF_Icons.profile,
                    color: Colors.black,
                    size: 32,
                  ),
                  trailing: Icon(
                    EDGF_Icons.profile,
                    color: Colors.black,
                    size: 32,
                  ),
                  title: Container(
                    alignment: Alignment.center,
                    child: Text('Friends'),
                  )),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(UserID)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  );
                } // if

                if (snapshot.hasError) {
                  return Container(child: Text('No Posts Found'));
                }

                if (snapshot.hasData) {
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      for (var i in snapshot.data['friends'])
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfileWidget(
                                        UserID: i,
                                      ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    width: deviceWidth * 0.95,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: ListTile(
                                      leading: FutureBuilder(
                                        future: AuthID_Userpfp(i),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          return new ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: new CachedNetworkImage(
                                              imageUrl:
                                                  snapshot.data.toString(),
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                      title: FutureBuilder(
                                        future: AuthID_Check_Premium(i),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.data['premium'] ==
                                              false) {
                                            return Text(
                                              snapshot.data['username']
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            );
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.black,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                snapshot.data['username']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      subtitle: FutureBuilder(
                                        future: AuthID_Status(i),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          return Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
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
                    ],
                  );
                }
                return Text('BAD');
              },
            ),
          ),
        ),
      ],
    );
  }
}
