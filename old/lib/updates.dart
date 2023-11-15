import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/extra/AppInformation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'extra/Hex.dart';


class update extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2b2b2b),
        title:  FutureBuilder(
          future: getVersion(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            var V = snapshot.data;
            return Text("Updates  |  v. $V");
          },
        )


      ),
      body: Container(
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
              height: deviceHeight * 0.848,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Updates').orderBy('Date', descending: true).snapshots(),
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
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {

                            return Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                    padding: EdgeInsets.all(15),

                                    width: deviceWidth * 0.8,
                                    decoration: BoxDecoration(
                                      color: HexColor('#faebd7'),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Container( //Title
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(document['Version-Name'],
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(document['Version-Name-Color']),
                                                ),
                                              ),
                                              Text(' '),
                                              Text(document['Version-Code'],
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(document['Version-Code-Color']),
                                                ),
                                              ),
                                            ]
                                          )
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
                                            // Message
                                            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                            child: ListView(
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [

                                                  for (var i in document['Description']) (

                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 2, 0, 3),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Container(
                                                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                            child: Text('--',
                                                            ),
                                                          ),

                                                          Flexible(
                                                            child: Text(
                                                              i,
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontStyle: FontStyle.italic,

                                                              ),

                                                            ),
                                                          )

                                                        ]
                                                    ),
                                                  )


                                                  )

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

                  return Text('Bad');

                },
              ),
            )

          ],
        ),
      ),
    );
  }

}