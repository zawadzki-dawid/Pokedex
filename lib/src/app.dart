import 'package:flutter/material.dart';

// Pages
import 'package:pokedex/src/pages/loading_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Route indicated in initial route always has priority before '/' route
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(),
      },
    );
  }
}
