import 'package:flutter/material.dart';
import 'package:pokedex/src/utils/api/poke_api.dart';
import 'package:pokedex/src/utils/models/pokemon.dart';

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

class WikiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context).settings.arguments;
    List<Pokemon> pokemons = args['loadedData'];
    print('el at 0: ${pokemons[0].name}; len of list: ${pokemons.length}');

    String title = 'Pokemon name'; // TODO receive from caller
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(title),
      ),
      body: Column(
        children: [
          BasicInfoCard(
            pokemon: pokemons[0],
          ),
        ],
      ),
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // margin: EdgeInsets.fromLTRB(0, top, right, bottom),
                  child: Text(
                    value.capitalize(),
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
