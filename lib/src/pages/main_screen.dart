import 'dart:ffi';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import '../utils/api/parsing_service.dart';
import '../utils/models/pokemon.dart';
import '../utils/api/poke_api.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:http/http.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class MainScreen extends StatefulWidget {
  final dynamic loadedData;
  MainScreen({@required this.loadedData});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController editingController = TextEditingController();
  var duplicateItems = List<Pokemon>();
  var items = List<Pokemon>();
  String searchValue = "";

  void loadData(int id) async {
    for (var i = 0; i < 476; i++) {

    }

    // dynamic pokemonsResponse = await PokeApi.getPokemonEvolution(id);
    // Map pokemonsData = jsonDecode(pokemonsResponse.body);
    // print(pokemonsData['chain']['evolves_to'][0]['species']['name']);
  }

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    searchValue = query;
    List<Pokemon> dummySearchList = List<Pokemon>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<Pokemon> dummyListData = List<Pokemon>();
      dummySearchList.forEach((item) {
        if (item.name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    try {
      duplicateItems = widget.loadedData["loadedData"];
    } catch(e) {
      duplicateItems = [];
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Main Screen"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5 / 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: new Card(
                        color: Colors.redAccent,
                        child: PokemonCard(pokemon: items[index])
                    ),
                    onTap: () {
                      // Navigator.pushNamed(context, '/wiki-page',
                      // arguments: {'id': pokemon.id});
                      print(items[index].id);
                      loadData(items[index].id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PokemonCard extends StatelessWidget {
  PokemonCard({this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Image.network(pokemon.imageUrl),
          Text(capitalize(pokemon.name)),
        ],
      ),
    );
  }
}

