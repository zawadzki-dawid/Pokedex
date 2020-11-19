import 'package:flutter/material.dart';
import 'package:pokedex/src/pages/loading_page.dart';
import 'package:pokedex/src/pages/wiki_page.dart';
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
              nextRoute: '/wiki-page',
            ),
        '/wiki-page': (context) => WikiPage(),
        '/main-screen': (context) => Container(),
        // TODO insert MainScreen component
      },
    );
  }
}
