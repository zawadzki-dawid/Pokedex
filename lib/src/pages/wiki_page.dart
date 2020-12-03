import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/src/utils/api/poke_api.dart';
import 'package:pokedex/src/utils/models/memory_handler.dart';
import '../locator.dart';
import '../utils/models/pokemon.dart';
import 'package:http/http.dart';
import 'dart:convert';

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

class WikiPage extends StatefulWidget {
  dynamic id;
  int args;
  final MemoryHandler _memoryHandler = locator<MemoryHandler>();
  final pokeApi = new PokeApi();

  WikiPage({@required id}) {
      this.id = id["id"];
  }
  @override
  _WikiPageState createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  Pokemon pokemon = null;

  void loadData() async {

    if(widget.id == 0) {
      widget.args = await widget._memoryHandler.drawAndDeleteIndex();
      print(widget.args);
    } else {
      widget.args = widget.id;
    }
    Response data = await PokeApi.getSpecificPokemonById(widget.args);
    Map pokemonsData = jsonDecode(data.body);
    setState(() {
      pokemon = new Pokemon(
          id: widget.args,
          name: pokemonsData["forms"][0]["name"],
          imageUrl: pokemonsData["sprites"]["front_default"]
      );
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    String title = pokemon != null ? pokemon.name : '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(title),
      ),
      body: pokemon != null ? Column(
        children:  [
          BasicInfoCard(
            pokemon: pokemon,
          ),
        ],
      ) : null,
    );
  }
}

class BasicInfoCard extends StatelessWidget {
  final Pokemon pokemon;

  BasicInfoCard({@required this.pokemon});

  @override
  Widget build(BuildContext context) {
      return Card(
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Align(
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                              pokemon.imageUrl,
                            )),
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red[400],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(45),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PokemonAttribute(name: 'Name', value: pokemon.name),
                    PokemonAttribute(name: 'Height', value: '32'),
                    PokemonAttribute(name: 'Type', value: 'Fire')
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }


class PokemonAttribute extends StatelessWidget {
  final String name;
  final String value;

  PokemonAttribute({@required this.name, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      child: Row(
        children: [
          Text(
            '$name:',
            style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // margin: EdgeInsets.fromLTRB(0, top, right, bottom),
                  child: Text(
                    value.capitalize(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
