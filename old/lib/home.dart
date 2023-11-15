import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/widgets/UserProfile.dart';
import 'package:edgermanflex/widgets/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'extra/Hex.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

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
          decoration: BoxDecoration(
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
                      padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
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
                              return SizedBox(
                                width: deviceWidth,
                                child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      return Row(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
                                              padding: EdgeInsets.all(10),
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
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container( // Color
                                                    height: 1,
                                                    width: deviceWidth * 0.6,
                                                    margin: EdgeInsets.fromLTRB(5, 7, 5, 0),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                  Container(
                                                      height: deviceHeight * 0.11,// Message
                                                      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
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

                            return Text('Bad!!');
                          },
                        )


                    ),
                  ],
                ),
              ),
              Container( // Title 2
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                alignment: Alignment.centerLeft,
                child: Text(
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),

                        ],
                      );
                    }  // if

                    if (snapshot.hasError) {
                      return Container(
                          child: Text('Error while Loading Posts')
                      );
                    }

                    if (snapshot.hasData) {

                      if (snapshot.data!.docs.isEmpty) {
                        return Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                            padding: EdgeInsets.all(10),
                            width: deviceWidth * 0.8,
                            decoration: BoxDecoration(
                              color: HexColor('#faebd7'),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container( //Title
                                  child: Text(
                                    'Zero Posts',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Row(
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
                                  margin: EdgeInsets.fromLTRB(5, 7, 5, 0),
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                      color: Colors.grey
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                    child: ListView(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        primary: false,
                                        scrollDirection: Axis.vertical,
                                        children: [
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
                            physics: BouncingScrollPhysics(),
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
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                    padding: EdgeInsets.all(10),
                                    height: deviceHeight * 0.23,
                                    width: deviceWidth * 0.8,
                                    decoration: BoxDecoration(
                                      color: HexColor('#faebd7'),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Container( //Title
                                          child: Text(
                                            document['Title'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
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
                                                    style: TextStyle(
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
                                          margin: EdgeInsets.fromLTRB(5, 7, 5, 0),
                                          alignment: Alignment.topLeft,
                                          decoration: BoxDecoration(
                                              color: Colors.grey
                                          ),
                                        ),
                                        Container(
                                            height: deviceHeight * 0.134,// Message
                                            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                            child: ListView(
                                                physics: BouncingScrollPhysics(),
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

                    return Text('Bad');

                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}