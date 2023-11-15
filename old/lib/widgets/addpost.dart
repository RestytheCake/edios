import 'package:edgermanflex/firebase/forumupload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forum.dart';

class addpost extends StatefulWidget {
  @override
  _addpoststate createState() => _addpoststate();
}

class _addpoststate extends State<addpost> {
  final titlec = TextEditingController();
  final messagec = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titlec.dispose();
    messagec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xff2b2b2b),
        title: Text('Create Post'),
      ),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/patterndark.png'),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                decoration: BoxDecoration(color: Color(0xfffff4e3)),
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        'Title',
                        style: TextStyle(
                          color: Color(0xff5b1000),
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 80,
                      width: deviceWidth * 0.88,
                      child: TextField(
                        controller: titlec,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        'Message',
                        style: TextStyle(
                          color: Color(0xff5b1000),
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 80,
                      width: deviceWidth * 0.88,
                      child: TextField(
                        controller: messagec,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Post',
        onPressed: () {
          if (titlec.text.isNotEmpty || messagec.text.isNotEmpty) {
            forumUpload(messagec.text, titlec.text);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => forum()),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
