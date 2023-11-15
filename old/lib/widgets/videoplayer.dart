import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class videoplayerWidget extends StatelessWidget {
  String videoID;
  String videoTitle;
  String playlist;
  videoplayerWidget(
      {required this.videoID,
      required this.videoTitle,
      required this.playlist});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Color(0xff2b2b2b),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/patterndark.png"),
                  fit: BoxFit.cover),
            ),
            width: deviceWidth,
            height: deviceHeight,
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
              ),
              builder: (Context, player) {
                return Column(
                  children: [
                    Hero(
                      tag: videoID,
                      child: player,
                    ),
                    Container(
                      //Playlist title
                      margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                      child: Text(
                        'All Videos from the Playlist',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      //Video
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Videos')
                              .doc('thumbnail')
                              .collection(playlist)
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
                                height: deviceHeight * 0.5,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    if (document['Id'] == videoID) {
                                      return SizedBox.shrink();
                                    }

                                    return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        (video())),
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        (videoplayerWidget(
                                                          videoID:
                                                              document['Id'],
                                                          videoTitle:
                                                              document['Title'],
                                                          playlist: document[
                                                              'Playlist'],
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
                                                  child: ColorFiltered(
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Colors.black54,
                                                              BlendMode.darken),
                                                      child: Image(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            document[
                                                                'thumbnail']),
                                                        height:
                                                            deviceHeight * 0.25,
                                                      ))),
                                            )));
                                  }).toList(),
                                ));
                          }),
                    ),
                  ],
                );
              },
            )));
  }
}
