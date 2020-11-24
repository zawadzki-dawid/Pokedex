import 'package:flutter/material.dart';
import 'package:pokedex/src/pages/loading_page.dart';
import 'package:pokedex/src/pages/wiki_page.dart';
import 'package:pokedex/src/pages/main_screen.dart';
import 'package:pokedex/src/utils/api/parsing_service.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
