import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase/auth-data.dart';

class Chatroom extends StatefulWidget{

  String EUID;
  String SUID;
  String RoomID;
  Chatroom({required this.EUID, required this.SUID, required this.RoomID});

  @override
  _chatroom createState() => _chatroom(EUID, SUID, RoomID);
}


// TODO: Fix screen bug to move with keyboard


class _chatroom extends State<Chatroom> {
  String EUID;
  String SUID;
  String RoomID;
  _chatroom(this.EUID, this.SUID, this.RoomID);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    final Textc = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2b2b2b),
        title: FutureBuilder(
          future: AuthID_Username(EUID),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot)
          {
            return Row(
              children: [
                Text('Chat with '),
                Text(snapshot.data.toString(),
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontStyle: FontStyle.italic,
                ),)
              ],
            );

          },
        ),
      ),
      body: Scaffold(
        backgroundColor: Color(0xff454443),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(10),
            width: deviceWidth,
            decoration: BoxDecoration(
              color: Color(0xff2b2b2b),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    height: deviceHeight * 0.08,
                    width: deviceWidth * 0.9,
                    child: TextField(
                      controller: Textc,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Send A Message',
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w300,
                            fontSize: 14
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  ),
                )

                // Message
              ],
            )
        ),
        body: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('userChat').doc(RoomID).collection(RoomID).orderBy('Created', descending: false).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                      if (!snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                          ],
                        );
                      }

                      if (snapshot.hasData) {
                        return ListView(
                              scrollDirection: Axis.vertical,
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {

                                if (document['Author'] == SUID) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue,
                                            ),
                                            child: Text(
                                              document['Message'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  );
                                }

                                else if (document['Author'] == EUID) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              document['Message'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black
                                              ),
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  );
                                }

                                else {
                                  return Text('What');
                                }

                              }).toList()
                          );
                      }

                      return Text('Bad!!');
                    },
                  ),
          )
    );
  }
}
