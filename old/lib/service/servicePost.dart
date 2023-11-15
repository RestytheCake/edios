import 'package:edgermanflex/widgets/SignUp.dart';
import 'package:edgermanflex/widgets/addpost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../friends.dart';

class servicePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
          body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasData) {
                  Get.to(addpost());
                  return Container();
                }
                else if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }
                else {
                  return SignUpWidget();
                }
              }
          )
      );
}