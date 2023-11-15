import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/extra/link.dart';
import 'package:edgermanflex/widgets/videoplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class video extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/patterndark.png"),
                fit: BoxFit.cover),
          ),
          width: deviceWidth,
          height: deviceHeight,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: Text(
                    'Updates',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Updates
                Container(
                  //Video
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Videos')
                          .doc('thumbnail')
                          .collection('Updates')
                          .orderBy('uploaded', descending: true)
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

                        return SizedBox(
                            height: deviceHeight * 0.2,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (videoplayerWidget(
                                                      videoID: document['Id'],
                                                      videoTitle:
                                                          document['Title'],
                                                      playlist:
                                                          document['Playlist'],
                                                    ))),
                                          );
                                        },
                                        onDoubleTap: () =>
                                            {openLink(document['URL'])},
                                        child: Hero(
                                            tag: document['Id'],
                                            child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['thumbnail'],
                                                width: deviceWidth * 0.6,
                                                fit: BoxFit.fill,
                                              ),
                                            ))));
                              }).toList(),
                            ));
                      }),
                ),

                Container(
                  //Title
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: Text(
                    'Character',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Character
                Container(
                  //Video
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Videos')
                          .doc('thumbnail')
                          .collection('Character')
                          .orderBy('uploaded', descending: true)
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

                        return SizedBox(
                            height: deviceHeight * 0.2,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (videoplayerWidget(
                                                      videoID: document['Id'],
                                                      videoTitle:
                                                          document['Title'],
                                                      playlist:
                                                          document['Playlist'],
                                                    ))),
                                          );
                                        },
                                        onDoubleTap: () =>
                                            {launch(document['URL'])},
                                        child: Hero(
                                            tag: document['Id'],
                                            child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['thumbnail'],
                                                width: deviceWidth * 0.6,
                                                fit: BoxFit.fill,
                                              ),
                                            ))));
                              }).toList(),
                            ));
                      }),
                ),

                Container(
                  //Title
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: Text(
                    'Boss Guide',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Boss Guide
                Container(
                  //Video
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Videos')
                          .doc('thumbnail')
                          .collection('Boss Guide')
                          .orderBy('uploaded', descending: true)
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

                        return SizedBox(
                            height: deviceHeight * 0.2,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (videoplayerWidget(
                                                      videoID: document['Id'],
                                                      videoTitle:
                                                          document['Title'],
                                                      playlist:
                                                          document['Playlist'],
                                                    ))),
                                          );
                                        },
                                        onDoubleTap: () =>
                                            {launch(document['URL'])},
                                        child: Hero(
                                            tag: document['Id'],
                                            child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['thumbnail'],
                                                width: deviceWidth * 0.6,
                                                fit: BoxFit.fill,
                                              ),
                                            ))));
                              }).toList(),
                            ));
                      }),
                ),

                Container(
                  //Title
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: Text(
                    'dmg.mp4',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // dmg.mp4
                Container(
                  //Video
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Videos')
                          .doc('thumbnail')
                          .collection('dmg.mp4')
                          .orderBy('uploaded', descending: true)
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

                        return SizedBox(
                            height: deviceHeight * 0.2,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (videoplayerWidget(
                                                      videoID: document['Id'],
                                                      videoTitle:
                                                          document['Title'],
                                                      playlist:
                                                          document['Playlist'],
                                                    ))),
                                          );
                                        },
                                        onDoubleTap: () =>
                                            {launch(document['URL'])},
                                        child: Hero(
                                            tag: document['Id'],
                                            child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['thumbnail'],
                                                width: deviceWidth * 0.6,
                                                fit: BoxFit.fill,
                                              ),
                                            ))));
                              }).toList(),
                            ));
                      }),
                ),

                Container(
                  //Title
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: Text(
                    'Explained',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Explained
                Container(
                  //Video
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Videos')
                          .doc('thumbnail')
                          .collection('Explained')
                          .orderBy('uploaded', descending: true)
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

                        return SizedBox(
                            height: deviceHeight * 0.2,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (videoplayerWidget(
                                                      videoID: document['Id'],
                                                      videoTitle:
                                                          document['Title'],
                                                      playlist:
                                                          document['Playlist'],
                                                    ))),
                                          );
                                        },
                                        onDoubleTap: () =>
                                            {launch(document['URL'])},
                                        child: Hero(
                                            tag: document['Id'],
                                            child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['thumbnail'],
                                                width: deviceWidth * 0.6,
                                                fit: BoxFit.fill,
                                              ),
                                            ))));
                              }).toList(),
                            ));
                      }),
                ),

                Container(
                  //Title
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: Text(
                    'Tips and Tricks',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Tips and Tricks
                Container(
                  //Video
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Videos')
                          .doc('thumbnail')
                          .collection('Tips and Tricks')
                          .orderBy('uploaded', descending: true)
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

                        return SizedBox(
                            height: deviceHeight * 0.2,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (videoplayerWidget(
                                                      videoID: document['Id'],
                                                      videoTitle:
                                                          document['Title'],
                                                      playlist:
                                                          document['Playlist'],
                                                    ))),
                                          );
                                        },
                                        onDoubleTap: () =>
                                            {launch(document['URL'])},
                                        child: Hero(
                                            tag: document['Id'],
                                            child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['thumbnail'],
                                                width: deviceWidth * 0.6,
                                                fit: BoxFit.fill,
                                              ),
                                            ))));
                              }).toList(),
                            ));
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
