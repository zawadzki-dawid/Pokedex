import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/src/pages/loading_page.dart';
import 'package:pokedex/src/pages/wiki_page.dart';
import 'package:pokedex/src/pages/main_screen.dart';
import 'package:pokedex/src/utils/api/parsing_service.dart';
import 'package:pokedex/src/utils/api/notification_service.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final push_notification_sevice = PushNotificationService();
    push_notification_sevice.initialize();

    return MaterialApp(
      // Route indicated in initial route always has priority before '/' route
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(
              getDataFunction: DataService.getAllPokemons,
              nextRoute: '/main-screen',
            ),
        // '/wiki-page': (context) => WikiPage(),
        '/main-screen': (context) => MainScreen(),
        // TODO insert MainScreen component
      },
    );
  }
}
