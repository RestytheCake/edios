import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:morgan/main.dart';
import 'package:morgan/utils/Authentication.dart';
import 'package:provider/provider.dart';

import '../firebase/auth-service.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/patterndark.png"),
              fit: BoxFit.cover),
        ),
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, deviceHeight * 0.05, 0, 30),
              child: const Text('Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text("Login with Google"),
                onPressed: () {
                  Authentication.signInWithGoogle(context: context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.microsoft, color: Colors.green),
                label: const Text("Login with Microsoft (google)"),
                onPressed: () async {
                  await Authentication.signInWithGoogle(context: context);
                  Navigator.push (
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) => MyHomePage(PageN: 3),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, deviceHeight * 0.27, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: const Text(
                      'Terms of Service',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: const Text(
                      'By using this App you agree to following list:',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 05, 30, 0),
                    width: deviceWidth,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1)  ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'We save your Account Data for User Profile',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ), // 1
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2)  ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'User Profiles are Public and can be seen by everyone',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ), // 2
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3)  ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Forum Posts and Comments are Public and can be seen by everyone',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ), // 1)
                          ],
                        ), // 3
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '4)  ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'You agree on Googles Terms of Service',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ), // 1)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
