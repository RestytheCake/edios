import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'firebase/auth-data.dart';

class settings extends StatefulWidget {
  @override
  _settings createState() => _settings();
}

class _settings extends State<settings> {

  bool News = false;
  bool Update = false;
  bool Forum = false;
  bool Comment = false;

  @override
  void initState() {
    shared();
    super.initState();
  }

  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xff2b2b2b),
      ),
      body: Row(
        children: [
          Container(
              width: deviceWidth,
              height: deviceHeight * 0.3,
              decoration: BoxDecoration(color: Color.fromRGBO(70, 70, 70, 30)),
              child: Row(
                // 1st part row
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 15, 0, 13),
                      width: deviceWidth * 0.33,
                      alignment: Alignment.topCenter,
                      child: FutureBuilder(
                        future: Auth_Userpfp(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return new ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: new CachedNetworkImage(
                              imageUrl: snapshot.data.toString(),
                              height: deviceWidth * 0.28,
                              width: deviceWidth * 0.28,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )),
                  Container(
                    width: deviceWidth * 0.53,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: FutureBuilder(
                              future: Auth_Check_Premium(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.data['premium'] == false) {
                                          return Text(
                                            snapshot.data['username'].toString(),
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 24
                                            ),
                                          );
                                      } else {
                                        return Shimmer.fromColors(
                                            baseColor: Colors.orange,
                                            highlightColor: Colors.white,
                                            child: Text(
                                              snapshot.data['username']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 24),
                                            ),
                                          );
                                      }
                                    },
                                  )),
                        Container(
                            child: FutureBuilder(
                              future: Auth_Status(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                      return Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                              color: Colors.deepOrangeAccent,
                                              fontSize: 20),
                                        );
                                    },
                                  )),
                        Container(
                            child: FutureBuilder(
                              future: Auth_UserUID(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                      return Text(
                                          'UID: ' + snapshot.data.toString(),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12),
                                        );
                                    },
                                  )),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            width: deviceWidth,
            height: deviceHeight,
            child: SettingsList(
              //Color: Color(0xff212122),
              sections: [
                SettingsSection(
                  title: Text('Profile',
                  style: TextStyle(
                      color: Colors.orange,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800)
                  ),

                  tiles: [
                    SettingsTile(
                      title: Text('Username',
                      style: TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold),
                      ),
                      trailing: Text('Current Username',
                      style: TextStyle(
                          color: Colors.white60, fontStyle: FontStyle.italic),
                      ),

                      leading: Icon(Icons.language),
                      onPressed: (BuildContext context) {},
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text('Notifications',
                  style: TextStyle(
                      color: Colors.orange,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800)
                  ),
                  tiles: [
                    SettingsTile.switchTile(
                      title: Text('News Notification',
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      leading: Icon(Icons.fingerprint),
                      onToggle: (bool value) {
                        setState(() {
                          News = value;
                        });
                      }, initialValue: null,
                    ),
                    SettingsTile.switchTile(
                      title: Text('Update Notification',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      leading: Icon(Icons.fingerprint),
                      onToggle: (bool value) {
                        setState(() {
                          Update = value;
                        });
                      }, initialValue: null,
                    ),
                    SettingsTile.switchTile(
                      title: Text('Forum Notification',
                        style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500),
                        ),
                      leading: Icon(Icons.fingerprint),
                      onToggle: (bool value) {
                        setState(() {
                          Forum = value;
                        });
                      }, initialValue: null,
                    ),
                    SettingsTile.switchTile(
                      title: Text('Comment Notification',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      leading: Icon(Icons.fingerprint),
                      onToggle: (bool value) {
                        setState(() {
                          Comment = value;
                        });
                      }, initialValue: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
