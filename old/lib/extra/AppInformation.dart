import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future AppVersion() async {
  var AppData = await FirebaseFirestore.instance.collection('App').doc('Information').get();
  var Version = AppData.data()!['Version'];

  if (Version == Null) {
    Version = 'Not Good';
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var AppV = prefs.getString('Version');

  return {
    'Version': Version,
    'AppV': AppV,
  };

}

Future FirstTimeOpened() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var fto = prefs.getString('FTO') ?? false;

  return fto;

}

Future<void> setFTO() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('FTO', true);

}


Future getVersion() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var V = prefs.getString('Version');

  return V;

}