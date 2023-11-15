import 'package:cloud_firestore/cloud_firestore.dart';
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
        backgroundColor: const Color(0xff2b2b2b),
        title:  const Text('Deleted!!!')
      ),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: const BoxDecoration(
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
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),

                      ],
                    );
                  }  // if

                  if (snapshot.hasError) {
                    return Container(
                        child: const Text('No Posts Found')
                    );
                  }

                  if (snapshot.hasData) {

                    return SizedBox(
                      width: deviceWidth,
                      child: ListView(
                          physics: const BouncingScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {

                            return Container(
                                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                                    padding: const EdgeInsets.all(15),

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
                                              const Text(' '),
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
                                          margin: const EdgeInsets.fromLTRB(5, 7, 5, 0),
                                          alignment: Alignment.topLeft,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey
                                          ),
                                        ), // Line
                                        Container(
                                            // Message
                                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                            child: ListView(
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [

                                                  for (var i in document['Description']) (

                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 3),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Container(
                                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                            child: const Text('--',
                                                            ),
                                                          ),

                                                          Flexible(
                                                            child: Text(
                                                              i,
                                                              style: const TextStyle(
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

                  return const Text('Bad');

                },
              ),
            )

          ],
        ),
      ),
    );
  }

}