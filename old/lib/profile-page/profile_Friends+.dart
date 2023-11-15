import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/firebase/auth-data.dart';
import 'package:edgermanflex/widgets/UserProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class profile_Friendsplus extends StatefulWidget {
  String UserID;
  String UserID2;
  profile_Friendsplus({required this.UserID, required this.UserID2});

  @override
  _profile_Friendsplus createState() => _profile_Friendsplus(UserID, UserID2);
}

class _profile_Friendsplus extends State<profile_Friendsplus> {
  String UserID;
  String UserID2;

  final findUserc = TextEditingController();

  _profile_Friendsplus(this.UserID, this.UserID2);

  @override
  void initState() {
    findUserc.addListener(() {
      if (findUserc.value.text.isEmpty) {
        setState(() {
          UserID2 = UserID;
        });
        print(UserID2);
      } else if (findUserc.value.text.isNotEmpty) {
        setState(() {
          UserID2 = findUserc.value.text.toString();
        });
        print(UserID2);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

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
                leading: Icon(FontAwesomeIcons.search),
                title: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  width: deviceWidth * 0.9,
                  child: TextField(
                    controller: findUserc,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Search User',
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (findUserc.value.text.isEmpty)
          (Container(
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
                  return Expanded(
                    child: ListView(
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
                    ),
                  );
                }
                return Text('BAD');
              },
            ),
          ))
        else if (findUserc.value.text.isNotEmpty)
          (Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .where('Username', isGreaterThanOrEqualTo: UserID2)
                  .where('Username', isLessThan: UserID2 + 'z')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  );
                } // if

                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView(
                          physics: BouncingScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfileWidget(
                                            UserID: document['UID'],
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
                                            future:
                                                AuthID_Userpfp(document['UID']),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
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
                                            future: AuthID_Check_Premium(
                                                document['id']),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          subtitle: FutureBuilder(
                                            future:
                                                AuthID_Status(document['UID']),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              return Text(
                                                snapshot.data.toString(),
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList()));
                }
                return Text('BAD');
              },
            ),
          )),
      ],
    );
  }
}
