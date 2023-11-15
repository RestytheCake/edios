import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> User_data() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.model}');

  FirebaseAuth Auth = FirebaseAuth.instance;
  String UID = Auth.currentUser!.uid.toString();
  String Name = Auth.currentUser!.displayName.toString();
  String pfp = Auth.currentUser!.photoURL.toString();
  String email = Auth.currentUser!.email.toString();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  CollectionReference Forum = FirebaseFirestore.instance.collection('User');

  final snapShot =
      await FirebaseFirestore.instance.collection('User').doc(UID).get();
  final fcmData = snapShot.data();

  if (!snapShot.exists) {
    Forum.doc(UID).set({
      'Username': Name,
      'UID': UID,
      'pfp': pfp,
      'Status': 'ED Player',
      'Email': email,
      'Liked': [],
      'friends': [],
      'Chat': [],
      'premium': false,
      'Notification': {
        'News': true,
        'Update': true,
        'Forum': true,
        'Comment': true,
      },
    });
  }

  print(fcmData);

  await FirebaseFirestore.instance
      .collection('User')
      .doc(UID)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    prefs.setBool('News', documentSnapshot.get('Notification.News'));
    prefs.setBool('Update', documentSnapshot.get('Notification.Update'));
    prefs.setBool('Forum', documentSnapshot.get('Notification.Forum'));
    prefs.setBool('Comment', documentSnapshot.get('Notification.Comment'));
  });
  FirebaseMessaging.instance.getToken().then(
        (value) => Forum.doc(UID).update({
          'fcm.${androidInfo.model}': value,
        }),
      );
}
