import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/Icons/e_d_g_f__icons_icons.dart';
import 'package:edgermanflex/extra/Hex.dart';
import 'package:edgermanflex/widgets/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profile_Comment extends StatelessWidget {

  String UserID;

  profile_Comment({required this.UserID});

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
              decoration: BoxDecoration(
                  color: HexColor('#faebd7'),
              ),
              child: ListTile(
                  leading: Icon(EDGF_Icons.forum, color: Colors.black, size: 32, ),
                  trailing: Icon(EDGF_Icons.forum, color: Colors.black, size: 32,),
                  title: Container(
                    alignment: Alignment.center,
                    child: Text('Forum Post Comments'),
                  )
              ),
            ),
          ),
        ),
        Expanded(
          child:  Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('userComment').where('UID', isEqualTo: UserID).snapshots(),
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
                        child: Text('No Comments Found')
                    );
                  }

                  if (snapshot.hasData) {
                    return  SizedBox(
                        height: deviceHeight * 0.6,
                        width: deviceWidth,
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
                                                DocID: document['PostID'],
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
                                          Container(
                                            child: Text(
                                              'Post Title :',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12
                                              ),
                                            ),
                                          ),
                                          Container( //Title
                                            child: Text(
                                              document['Posttitle'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ), // Title

                                          Container( // Color
                                            height: 1,
                                            width: deviceWidth * 0.8,
                                            margin: EdgeInsets.fromLTRB(5, 7, 5, 0),
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                            ),
                                          ), // Line

                                          Container(
                                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Comment :',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12
                                              ),
                                            ),
                                          ),

                                          Container(
                                              height: deviceHeight * 0.114,// Message
                                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                              child: ListView(
                                                  physics: BouncingScrollPhysics(),
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.vertical,
                                                  children: [
                                                    Text(
                                                        document['Message']
                                                    ),
                                                  ]
                                              )
                                          ), // Message
                                        ],
                                      )
                                  )
                              );

                            }).toList()
                        )
                    );

                  }

                  return Text('BAD!!!');
                },
              )
          ),
        )
      ],
    );
  }
}