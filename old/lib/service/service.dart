import 'package:edgermanflex/firebase/auth-data.dart';
import 'package:edgermanflex/profile.dart';
import 'package:edgermanflex/widgets/SignUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class serviceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Auth_isloggedin()) {
      return profileWidget();
    }
    else {
      return SignUpWidget();
    }
  }
}
