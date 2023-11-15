import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Auth_isloggedin<bool>() {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  } else {
    return false;
  }
}

Future<Map> Auth_Scaffold_title() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user;

    String UserID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = {
        'Username': documentSnapshot.get('Username'),
        'isloggedin': true,
      };
    });
    return user;
  } else {
    return {
      'Username': 'New User',
      'isloggedin': false,
    };
  }
}

Future<dynamic> Auth_Check_Premium() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var username;
    var premium;

    String UserID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      username = documentSnapshot.get('Username');
      premium = documentSnapshot.get('premium');
    });
    return {'username': username, 'premium': premium};
  } else {
    return 'Not logged in';
  }
}

Future<String> Auth_Username() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user;

    String UserID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = documentSnapshot.get('Username');
    });
    return user;
  } else {
    return 'Not logged in';
  }
}

Future<String> Auth_Userpfp() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user;

    String UserID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = documentSnapshot.get('pfp');
    });
    return user;
  } else {
    return 'Not logged in';
  }
}

Future<String> Auth_Status() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var userStatus;

    String UserID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      userStatus = documentSnapshot.get('Status');
    });
    return userStatus;
  } else {
    return 'Not logged in';
  }
}

Future<String> Auth_UserUID() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user;

    String UserID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = documentSnapshot.get('UID');
    });
    return user;
  } else {
    return 'Not logged in';
  }
}


// ~~~~~~~~~~~~~~~~~~~~~~~ User ID For Other User ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Future<dynamic> AuthID_Check_Premium(String UserID) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var username;
    var premium;

    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      username = documentSnapshot.get('Username');
      premium = documentSnapshot.get('premium');
    });
    return {'username': username, 'premium': premium};
  } else {
    return 'Not logged in';
  }
}

Future<String> AuthID_Username(String UserID) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user;

    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = documentSnapshot.get('Username');
    });
    return user;
  } else {
    return 'Not logged in';
  }
}

Future<String> AuthID_Userpfp(String UserID) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user;

    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = documentSnapshot.get('pfp');
    });
    return user;
  } else {
    return 'Not logged in';
  }
}

Future<String> AuthID_Status(String UserID) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var userStatus;

    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      userStatus = documentSnapshot.get('Status');
    });
    return userStatus;
  } else {
    return 'Not logged in';
  }
}

Future<String> AuthID_UserUID(String UserID) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user;

    await FirebaseFirestore.instance
        .collection('User')
        .doc(UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = documentSnapshot.get('UID');
    });
    return user;
  } else {
    return 'Not logged in';
  }
}
