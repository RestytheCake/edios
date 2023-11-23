import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:morgan/service/servicePost.dart';
import 'package:morgan/widgets/UserProfile.dart';
import 'package:morgan/widgets/addpost.dart';
import 'package:shimmer/shimmer.dart';

import 'extra/Hex.dart';
import 'firebase/auth-data.dart';

class forum extends StatefulWidget {
  @override
  _forum createState() => _forum();
}

class _forum extends State<forum> {
  late var Search;

  final findUserc = TextEditingController();

  @override
  void initState() {
    findUserc.addListener(() {
      if (findUserc.value.text.isEmpty) {
        setState(() {
          Search = '';
        });
      } else if (findUserc.value.text.isNotEmpty) {
        setState(() {
          Search = findUserc.value.text.toString();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/patterndark.png"),
              fit: BoxFit.cover),
        ),
        width: 5000,
        height: 5000,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: deviceWidth * 0.9,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.search),
                    title: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      width: deviceWidth * 0.9,
                      child: TextField(
                        autofocus: false,
                        controller: findUserc,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Search Post',
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
              (StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userPost')
                    .orderBy('Created', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ],
                    );
                  } // if

                  if (snapshot.hasError) {
                    return Container(child: const Text('No Posts Found'));
                  }

                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                          physics: const BouncingScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return GestureDetector(
                                child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(20, 10, 20, 5),
                                    padding: const EdgeInsets.all(10),
                                    height: deviceHeight * 0.23,
                                    width: deviceWidth * 0.8,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          //Title
                                          child: Text(
                                            document['Title'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ), // Title
                                        Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            child:  Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'by: ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                GestureDetector(
                                                    onTap:
                                                        () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                              UserProfileWidget(
                                                                UserID: document['UID'],
                                                              )),
                                                    ),
                                                    child: FutureBuilder(
                                                      future:
                                                      AuthID_Check_Premium(
                                                          document[
                                                          'UID']),
                                                      builder: (BuildContext
                                                      context,
                                                          AsyncSnapshot<
                                                              dynamic>
                                                          snapshot) {
                                                        if (snapshot.data[
                                                        'premium'] ==
                                                            false) {
                                                          return Text(
                                                            document['User']
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepOrangeAccent,
                                                                fontStyle:
                                                                FontStyle
                                                                    .italic,
                                                                fontSize: 12),
                                                          );
                                                        } else {
                                                          return Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .deepOrangeAccent,
                                                            highlightColor:
                                                            Colors.white,
                                                            child: Text(
                                                              document['User']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                                  fontSize:
                                                                  12),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    )),
                                              ],
                                            )), // User Name
                                        Container(
                                          // Color
                                          height: 1,
                                          width: deviceWidth * 0.8,
                                          margin:
                                              const EdgeInsets.fromLTRB(5, 7, 5, 0),
                                          alignment: Alignment.topLeft,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey),
                                        ), // Line
                                        Container(
                                            height: deviceHeight *
                                                0.134, // Message
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 10, 5, 0),
                                            child: ListView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.vertical,
                                                children: [
                                                  Text(document['Message']),
                                                ])), // Message
                                      ],
                                    )));
                          }).toList()),
                    );
                  }

                  return const Text('Bad');
                },
              ))
            else if (findUserc.value.text.isNotEmpty)
              (Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('userPost')
                      .where('Title', isGreaterThanOrEqualTo: Search)
                      .where('Title', isLessThan: Search + 'z')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ],
                      );
                    } // if

                    if (snapshot.hasData) {
                      return Expanded(
                          child: ListView(
                              physics: const BouncingScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return GestureDetector(

                                    child: Container(
                                        margin:
                                            const EdgeInsets.fromLTRB(20, 10, 20, 5),
                                        padding: const EdgeInsets.all(10),
                                        height: deviceHeight * 0.23,
                                        width: deviceWidth * 0.8,
                                        decoration: BoxDecoration(
                                          color: HexColor('#faebd7'),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              //Title
                                              child: Text(
                                                document['Title'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ), // Title
                                            Container(
                                                margin: const EdgeInsets.fromLTRB(
                                                    0, 5, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'by: ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black),
                                                    ),
                                                    GestureDetector(
                                                        onTap:
                                                            () =>
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              UserProfileWidget(
                                                                                UserID: document['UID'],
                                                                              )),
                                                                ),
                                                        child: FutureBuilder(
                                                          future:
                                                              AuthID_Check_Premium(
                                                                  document[
                                                                      'UID']),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      dynamic>
                                                                  snapshot) {
                                                            if (snapshot.data[
                                                                    'premium'] ==
                                                                false) {
                                                              return Text(
                                                                document['User']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .deepOrangeAccent,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    fontSize:
                                                                        12),
                                                              );
                                                            } else {
                                                              return Shimmer
                                                                  .fromColors(
                                                                baseColor: Colors
                                                                    .deepOrangeAccent,
                                                                highlightColor:
                                                                    Colors
                                                                        .white,
                                                                child: Text(
                                                                  document[
                                                                          'User']
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        )),
                                                  ],
                                                )), // User Name
                                            Container(
                                              // Color
                                              height: 1,
                                              width: deviceWidth * 0.8,
                                              margin: const EdgeInsets.fromLTRB(
                                                  5, 7, 5, 0),
                                              alignment: Alignment.topLeft,
                                              decoration: const BoxDecoration(
                                                  color: Colors.grey),
                                            ), // Line
                                            Container(
                                                height: deviceHeight *
                                                    0.134, // Message
                                                padding: const EdgeInsets.fromLTRB(
                                                    5, 10, 5, 0),
                                                child: ListView(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    children: [
                                                      Text(document['Message']),
                                                    ])), // Message
                                          ],
                                        )));
                              }).toList()));
                    }
                    return const Text('BAD');
                  },
                ),
              )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff2b2b2b),
        tooltip: 'Add Post',
        onPressed: () {
          if (Auth_isloggedin()) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => addpost()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => servicePost()));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
