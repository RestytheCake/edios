import 'dart:io';

import 'package:http/http.dart' as http;

class Api {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = "AAAAG_9Z-qw:APA91bFKchzDMyBWYRTgVrvdComFJK7lUaSPQQGJ5stDTPNMa_hHil9zIT1DSATvyPdBhXWj0Lg7y_gn_BF5lKFajEfylhfSrIL6Osve0W85gdXfAUymeA--SZ9H4FIGTbKUu7rv33s9";

  void sendFcm(String title, String body, List fcmToken) async {

    for (var i in fcmToken) {
      var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
      var request = http.Request('POST', Uri.parse(fcmUrl));
      request.body = '''{"to":"$i","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }


  }
}