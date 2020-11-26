import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebase_messaging = FirebaseMessaging();

  Future initialize() async {
    _firebase_messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('message: onMessage');
      },
      onResume: (Map<String, dynamic> message) async {
        print('message: onResume');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('message: onLaunch');
      }
      );
  }

  Future onClickHandler(Map<String, dynamic> message) async {
    //Navigator.pushReplacementNamed(context, widget.nextRoute,
      //  arguments: {'pokemonIdx': 1});
  }
}