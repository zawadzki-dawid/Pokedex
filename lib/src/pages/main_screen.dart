import 'dart:ffi';
import 'package:flutter/material.dart';
import '../utils/api/parsing_service.dart';
import '../utils/models/pokemon.dart';
import 'package:http/http.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    var pokemons = ModalRoute.of(context).settings.arguments;
    print(pokemons);
    List<int> text = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Container(
          child: ListView(children: <Widget>[
            for (var pokemon in pokemons)
              Card(
                child:
                  ListTile(leading: CircleAvatar(
                    backgroundImage: NetworkImage(pokemon.imageUrl)), title: Text(capitalize(pokemon.name)))),
      ])),
    );
  }
}
