import 'package:flutter/material.dart';
import 'package:pokedex/src/pages/loading_page.dart';
import 'package:pokedex/src/pages/wiki_page.dart';
import 'package:pokedex/src/pages/main_screen.dart';
import 'package:pokedex/src/utils/api/parsing_service.dart';
import 'package:pokedex/src/utils/api/notification_service.dart';
import 'package:pokedex/src/utils/models/navigation_service.dart';
import 'locator.dart';

class App extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService();
    pushNotificationService.initialize();

    return MaterialApp(
      // Route indicated in initial route always has priority before '/' route
      navigatorKey: _navigationService.navigatorKey,
      home: MainScreen(
        getDataFunction: DataService.getAllPokemons,
      ),
      onGenerateRoute: (routeSettings) {
        switch(routeSettings.name) {
          case 'wiki-page':
            return MaterialPageRoute(builder: (context) => WikiPage(
              id: routeSettings.arguments
            ));
        }
    },
    );
  }
}
