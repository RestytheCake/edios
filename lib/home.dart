import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morgan/widgets/UserProfile.dart';
import 'package:morgan/widgets/comment.dart';

import 'extra/Hex.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/patterndark.png"),
                fit: BoxFit.cover
            ),
          ),
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              // Top Banner
              Container(
                width: deviceWidth,
                height: deviceHeight * 0.30,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Announcements',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22
                        ),
                      ),
                    ), // Title
                    Container(
                        height: deviceHeight * 0.2,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('Announcements').orderBy('Created', descending: true).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (!snapshot.hasData) {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                ],
                              );
                            }  // if

                            if (snapshot.hasError) {
                              return const Text('No Posts Found');
                            }

                            if (snapshot.hasData) {
                              return SizedBox(
                                width: deviceWidth,
                                child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      return Row(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                                              padding: const EdgeInsets.all(10),
                                              height: deviceHeight * 0.18,
                                              width: deviceWidth * 0.7,
                                              decoration: BoxDecoration(
                                                color: HexColor('#faebd7'),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container( //Title
                                                    alignment: Alignment.topCenter,
                                                    child: Text(
                                                      document['Title'],
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container( // Color
                                                    height: 1,
                                                    width: deviceWidth * 0.6,
                                                    margin: const EdgeInsets.fromLTRB(5, 7, 5, 0),
                                                    alignment: Alignment.center,
                                                    decoration: const BoxDecoration(
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                  Container(
                                                      height: deviceHeight * 0.11,// Message
                                                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                                      child: ListView(
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.vertical,
                                                          children: [
                                                            Text(
                                                                document['Message']
                                                            ),
                                                          ]
                                                      )
                                                  ),
                                                ],
                                              )
                                          ),

                                        ],
                                      );
                                    }).toList()
                                ),
                              );
                            }

                            return const Text('Bad!!');
                          },
                        )
                    ),
                  ],
                ),
              ),
              Container( // Title 2
                padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Daily Posts',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22
                  ),
                ),
              ),

              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('userPost').where('Date.Day', isEqualTo: DateTime.now().day).where('Date.Month', isEqualTo: DateTime.now().month).where('Date.Year', isEqualTo: DateTime.now().year).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (!snapshot.hasData) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),

                        ],
                      );
                    }  // if

                    if (snapshot.hasError) {
                      return const Text('Error while Loading Posts');
                    }

                    if (snapshot.hasData) {

                      if (snapshot.data!.docs.isEmpty) {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            padding: const EdgeInsets.all(10),
                            width: deviceWidth * 0.8,
                            decoration: BoxDecoration(
                              color: HexColor('#faebd7'),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Zero Posts',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'by: System' ,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black
                                          ),
                                        ),
                                      ],
                                    )

                                ),
                                Container( // Color
                                  height: 1,
                                  width: deviceWidth * 0.8,
                                  margin: const EdgeInsets.fromLTRB(5, 7, 5, 0),
                                  alignment: Alignment.topLeft,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                    child: ListView(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        primary: false,
                                        scrollDirection: Axis.vertical,
                                        children: const [
                                          Text(
                                              'No Daily Posts where Found for Today'
                                          ),
                                        ]
                                    )
                                ),
                              ],
                            )
                        );
                      }

                      return SizedBox(
                        height: deviceHeight * 0.515,
                        child: ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: snapshot.data!.docs.map((DocumentSnapshot document) {

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => (
                                            comment(
                                              DocID: document.id,
                                              UID: document['UID'],
                                              posttitle: document['Title'],
                                            )
                                        )
                                    ),
                                  );
                                },
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                                    padding: const EdgeInsets.all(10),
                                    height: deviceHeight * 0.23,
                                    width: deviceWidth * 0.8,
                                    decoration: BoxDecoration(
                                      color: HexColor('#faebd7'),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          document['Title'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'by: ' ,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => UserProfileWidget(UserID: document['UID'],))
                                                  ),
                                                  child: Text(
                                                    document['User'],
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.deepOrangeAccent
                                                    ),
                                                  ),
                                                ),


                                              ],
                                            )

                                        ),
                                        Container( // Color
                                          height: 1,
                                          width: deviceWidth * 0.8,
                                          margin: const EdgeInsets.fromLTRB(5, 7, 5, 0),
                                          alignment: Alignment.topLeft,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey
                                          ),
                                        ),
                                        Container(
                                            height: deviceHeight * 0.134,// Message
                                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                            child: ListView(
                                                physics: const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Text(
                                                      document['Message']
                                                  ),
                                                ]
                                            )
                                        ),
                                      ],
                                    )
                                ),
                              );
                            }).toList()
                        ),
                      );
                    }

                    return const Text('Bad');

                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}