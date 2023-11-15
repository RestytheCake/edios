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
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/patterndark.png"),
                fit: BoxFit.cover),
          ),
          width: deviceWidth,
          height: deviceHeight,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: const Text(
                    'Updates',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Updates
                Container(
                  //Video
                  child: Text('Stream 1'),
                ),

                Container(
                  //Title
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: const Text(
                    'Character',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Character
                Container(
                  //Video
                  child: Text('Stream 2'),
                ),

                Container(
                  //Title
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: const Text(
                    'Boss Guide',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Boss Guide
                Container(
                  //Video
                  child: Text('Stream 3')
                ),

                Container(
                  //Title
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: const Text(
                    'dmg.mp4',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // dmg.mp4
                Container(
                  //Video
                  child: Text('Stream 4'),
                ),

                Container(
                  //Title
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: const Text(
                    'Explained',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Explained
                Container(
                  //Video
                  child: Text('Stream 5'),
                ),

                Container(
                  //Title
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: const Text(
                    'Tips and Tricks',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Tips and Tricks
                Container(
                  //Video
                  child: Text('Stream 6'),
                ),
              ],
            ),
          ),
        ));
  }
}
