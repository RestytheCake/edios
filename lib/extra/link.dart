import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String link) async {
  if(await canLaunch(link)) {
    launch(link);
  }
  else {
    print("Can't launch link : " + link);
  }
}