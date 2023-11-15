import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

Future FriendCheck(String FID) async {

    String UserID = FirebaseAuth.instance.currentUser!.uid;

    var User = FirebaseFirestore.instance.collection('User');

    var Userget = await FirebaseFirestore.instance.collection('User').doc(UserID).get();
    var UserData = Userget.data();
    Map<dynamic, dynamic> UserFriends = UserData!['Chat'];

    if (UserFriends.containsKey(FID)) {
      return UserData['Chat'][FID];
    }

    else {
      var uuid = Uuid().v4();
      User.doc(UserID).update(
        {
          'Chat.$FID': uuid,
        }
      );
      User.doc(FID).update(
          {
            'Chat.$UserID': uuid,
          }
      );

      return UserData['Chat'][FID];
    }



}