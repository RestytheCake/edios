import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgermanflex/extra/toList.dart';
import 'package:edgermanflex/firebase/auth-data.dart';
import 'package:edgermanflex/firebase/fcm.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> forumUpload(String message, String title) async {
  CollectionReference Forum = FirebaseFirestore.instance.collection('userPost');
  FirebaseAuth Auth = FirebaseAuth.instance;
  String UID = Auth.currentUser!.uid.toString();

  Auth_Username().then((value) => Forum.add({
        'Date': {
          'Day': DateTime.now().day,
          'Month': DateTime.now().month,
          'Year': DateTime.now().year,
        },
        'Created': DateTime.now(),
        'Message': message,
        'Title': title,
        'UID': UID,
        'User': value,
        'Like': 0,
        'Comments': 0,
      }).then((value) => Forum.doc(value.id).update({'DocID': value.id})));
}

Future<void> commentUpload(
    String message, String PostID, String UserID, String Posttitle) async {
  var User =
      await FirebaseFirestore.instance.collection('User').doc(UserID).get();
  var UserData = User.data();

  CollectionReference Comment =
      FirebaseFirestore.instance.collection('userComment');
  CollectionReference Forum = FirebaseFirestore.instance.collection('userPost');

  final data =
      await FirebaseFirestore.instance.collection('userPost').doc(PostID).get();

  FirebaseAuth Auth = FirebaseAuth.instance;

  String UID = Auth.currentUser!.uid.toString();
  String Name = Auth.currentUser!.displayName.toString();

  Map fcmtoken = UserData!['fcm'];
  List Token = fcmtoken.toList((e) => e.value);

  String ptitle = data['Title'];

  var title = 'Comment from User : $Name on Post : $ptitle';
  var body = message;

  Comment.add({
    'PostID': PostID,
    'Posttitle': Posttitle,
    'Created': DateTime.now(),
    'Message': message,
    'UID': UID,
    'User': Name,
  }).then((value) => Comment.doc(value.id).update({'DocID': value.id}));

  Forum.doc(PostID).update({
    'Comments': data['Comments'] + 1,
  });

  Api().sendFcm(title, body, Token);
}

Future LikeChecker(String DocID) async {
  FirebaseAuth Auth = FirebaseAuth.instance;
  String UID = Auth.currentUser!.uid.toString();

  final check = await FirebaseFirestore.instance
      .collection("User")
      .where('UID', isEqualTo: UID)
      .where("Liked", arrayContains: DocID)
      .get();

  if (check.docs.isEmpty) {
    return false;
  } else {
    return true;
  }
}

Future<void> likeAdder(String DocID) async {
  FirebaseAuth Auth = FirebaseAuth.instance;
  String UID = Auth.currentUser!.uid.toString();

  CollectionReference Forum = FirebaseFirestore.instance.collection('userPost');
  final data =
      await FirebaseFirestore.instance.collection('userPost').doc(DocID).get();

  CollectionReference User = FirebaseFirestore.instance.collection('User');

  final check = await FirebaseFirestore.instance
      .collection("User")
      .where('UID', isEqualTo: UID)
      .where("Liked", arrayContains: DocID)
      .get();

  if (check.docs.isEmpty) {
    var uid = [UID];
    Forum.doc(DocID).update({
      'Like': data['Like'] + 1,
      'Liked': FieldValue.arrayUnion(uid),
    });
    var list = [DocID];
    User.doc(UID).update({'Liked': FieldValue.arrayUnion(list)});
  } else {
    var uid = [UID];
    Forum.doc(DocID).update({
      'Like': data['Like'] - 1,
      'Liked': FieldValue.arrayRemove(uid),
    });
    var Doc = [DocID];
    User.doc(UID).update({
      'Liked': FieldValue.arrayRemove(Doc),
    });
  }
}
