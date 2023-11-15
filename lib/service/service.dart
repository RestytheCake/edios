import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase/auth-data.dart';
import '../profile.dart';
import '../widgets/SignUp.dart';

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
