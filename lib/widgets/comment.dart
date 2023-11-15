import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../extra/Hex.dart';
import '../firebase/auth-data.dart';
import '../firebase/forumupload.dart';
import 'UserProfile.dart';


class comment extends StatefulWidget{

  String UID;
  String DocID;
  String posttitle;
  comment({required this.DocID, required this.UID, required this.posttitle});

  @override
  _comment createState() => _comment(DocID, UID, posttitle);
}

class _comment extends State<comment> {

  String UID;
  String DocID;
  String posttitle;
  _comment(this.DocID, this.UID, this.posttitle);

  final commentc = TextEditingController();

  @override
  void dispose() {
    commentc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    bool heart = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2b2b2b),
        toolbarHeight: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/patterndark.png"),
              fit: BoxFit.cover
          ),
        ),
        width: 5000,
        height: 5000,
        child: Column(
            children: <Widget>[
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('userPost').where('DocID', isEqualTo: DocID).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData) {
                      return SizedBox(
                        width: deviceWidth,
                        child: ListView(
                            physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {

                            return Container(
                                padding: EdgeInsets.all(10),
                                height: deviceHeight * 0.27,
                                width: deviceWidth,
                                decoration: BoxDecoration(
                                  color: HexColor('#faebd7'),
                                ),
                                child: Column(
                                  children: [
                                    Container(//Title
                                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        document['Title'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ), // Title
                                    Container(
                                        margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'by: ' ,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                fontStyle: FontStyle.italic,
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
                                                  color: Colors.deepOrangeAccent,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              )
                                            ),
                                            ]
                                        )
                                    ), // User Name
                                    Container( // Color
                                      height: 1,
                                      width: deviceWidth,
                                      margin: EdgeInsets.fromLTRB(5, 7, 5, 0),
                                      alignment: Alignment.topLeft,
                                      decoration: BoxDecoration(
                                          color: Colors.grey
                                      ),
                                    ), // Line
                                    Container(
                                        height: deviceHeight * 0.174,// Message
                                        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                        child: ListView(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            primary: false,
                                            children: [
                                              Text(
                                                  document['Message']
                                              ),
                                            ]
                                        )
                                    ), // Message
                                  ],
                                )
                            );

                          }).toList()
                        ),
                      );
                    }
                    return Text('Comment');
                  }
              ), // Post
              Container(
                height: deviceHeight * 0.05,
                width: deviceWidth,
                child:
                  Row(
                    children: [
                      Container(
                        height: deviceHeight * 0.05,
                        width: deviceWidth * 0.7,
                        decoration: BoxDecoration(
                          color: Color(0xff2e0000),
                        ),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('userPost').where('DocID', isEqualTo: DocID).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasData) {

                                return ListView(
                                    shrinkWrap: true,
                                    primary: false,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {

                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          FutureBuilder(
                                            future: LikeChecker(DocID),
                                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                              return GestureDetector(
                                                onTap: () => {
                                                  likeAdder(DocID)
                                                },
                                                onDoubleTap: () => {},

                                                child:

                                                Container(
                                                  margin: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                                  child: Image(
                                                      image:
                                                        heart == snapshot.data?
                                                        AssetImage('assets/images/heart2.png')
                                                        :AssetImage('assets/images/heart1.png'),
                                                    height: deviceHeight * 0.065,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                      // Heart
                                      Container(
                                      margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                      child: Text(
                                      document['Like'].toString(),
                                      style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.white,
                                              ),
                                            ),
                                          ), // Like Number
                                          Container(
                                            margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                            child: Image(
                                              image: AssetImage('assets/images/comment.png'),
                                              height: deviceHeight * 0.065,
                                            ),
                                          ), // Comment
                                          Container(
                                            margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                            child: Text(
                                              document['Comments'].toString(),
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList()
                                );

                              }
                              return Text('Comment');
                            }
                        ),
                      ),

                      Container(
                        height: deviceHeight * 0.05,
                        width: deviceWidth * 0.3,
                        decoration: BoxDecoration(
                          color: Color(0xff72270b),
                        ),
                      ),
                    ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  width: deviceWidth,
                  decoration: BoxDecoration(
                    color: HexColor('#faebd7'),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: deviceWidth * 0.2,
                        height: deviceHeight * 0.085,
                        child: FutureBuilder(
                          future: Auth_Userpfp(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage:
                              NetworkImage(snapshot.data.toString()),
                            );
                          },
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
                        width: deviceWidth * 0.64,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: TextField(
                                controller: commentc,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Write your Comment',
                                  hintStyle: TextStyle(

                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: deviceHeight * 0.1,
                        width: deviceWidth * 0.1,
                        child: GestureDetector(
                          onTap: () {
                            if (commentc.text.isNotEmpty) {
                              commentUpload(commentc.text, DocID, UID, posttitle);
                              commentc.clear();
                            }
                          },
                          child: Image(
                            image: AssetImage('assets/images/arrow.png'),
                          ),
                        ),
                      ),
                      // Message
                    ],
                  )
              ), // Create Comment
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('userComment').where('PostID', isEqualTo: DocID).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData) {
                      return Expanded(
                        child: SizedBox(
                          width: deviceWidth,
                          child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {

                                return Container(
                                    padding: EdgeInsets.all(10),
                                    width: deviceWidth,
                                    decoration: BoxDecoration(
                                      color: HexColor('#faebd7'),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: deviceWidth * 0.2,
                                          height: deviceHeight * 0.085,
                                          child: FutureBuilder(
                                            future: AuthID_Userpfp(document['UID']),
                                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                              return CircleAvatar(
                                                radius: 30,
                                                backgroundImage:
                                                NetworkImage(snapshot.data.toString()),
                                              );
                                            },
                                          ),

                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
                                          width: deviceWidth * 0.74,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  document['User'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  document['Message'],
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Message
                                      ],
                                    )
                                );

                              }).toList()
                          ),
                        ),
                      );
                    }
                    return Text('Comment');
                  }
              ), // Comments
              // Like and Comment
            ]
        ),
      ),
    );
  }
}
