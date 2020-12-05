import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokedex/src/utils/api/poke_api.dart';
import 'package:pokedex/src/utils/extensions/string.dart';
import 'package:pokedex/src/utils/models/pokemon.dart';
import 'package:pokedex/src/utils/models/ability.dart';

class WikiPage extends StatefulWidget {
  final int id; // Pokemon's ID in PokeApi

  WikiPage({@required this.id});

  @override
  _WikiPageState createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  Pokemon pokemon;

  void loadData() async {
    Response responseData = await PokeApi.getSpecificPokemonById(widget.id);
    Map pokemonData = jsonDecode(responseData.body);
    assert(widget.id == pokemonData["id"],
        "wiki-page: provided pokemon id and fetched id are different!");

    setState(() {
      pokemon = new Pokemon(
          id: pokemonData["id"],
          name: pokemonData["name"],
          imageUrl: pokemonData["sprites"]["front_default"],
          weight: pokemonData["weight"],
          height: pokemonData["height"],
          abilities: <Ability>[]);
    });

    List moves = pokemonData["moves"];
    for (dynamic moveItem in moves) {
      Response moveResponseData = await get(moveItem["move"]["url"]);
      Map moveData = jsonDecode(moveResponseData.body);
      Ability ability = new Ability(
          id: moveData["id"],
          name: moveData["name"],
          accuracy: moveData["accuracy"],
          power: moveData["power"],
          type: moveData["type"]["name"],
          damageClass: moveData["damage_class"]["name"],
          description: moveData["flavor_text_entries"][0]["flavor_text"]);
      setState(() {
        pokemon.abilities.add(ability);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pokemon = Pokemon();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    String title = pokemon != null ? pokemon.name.capitalize() : '';
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text(title),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              // height: 200,
              color: Colors.white30,
              child: BasicInfoCard(
                pokemon: pokemon,
              ),
            ),
            Container(
              height: 230,
              // width: 400,
              color: Colors.white30,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pokemon.abilities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AbilityCard(ability: pokemon.abilities[index]);
                },
              ),
            )
          ],
        )));
  }
}

class BasicInfoCard extends StatelessWidget {
  final Pokemon pokemon;

  BasicInfoCard({@required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
      elevation: 5,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Align(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: pokemon.imageUrl != null
                              ? NetworkImage(
                                  pokemon.imageUrl,
                                )
                              : AssetImage('lib/assets/pokeball.webp')),
                    ),
                  ),
                ),
              )),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red[400],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(45),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PokemonAttribute(
                      name: 'Name', value: pokemon != null ? pokemon.name : ''),
                  PokemonAttribute(
                      name: 'Weight',
                      value: pokemon != null ? '${pokemon.weight}' : ''),
                  PokemonAttribute(
                      name: 'Height',
                      value: pokemon != null ? '${pokemon.height}' : '')
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                      color: Colors.black,
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

// class AbilitiesCard extends StatelessWidget {
//   final List<Ability> abilities;
//
//   AbilitiesCard({@required this.abilities});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
//       elevation: 5,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Abilities',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Column(
//             children: abilities
//                 .map((ability) => AbilityCard(ability: ability))
//                 .toList(),
//           )
//         ],
//       ),
//     );
//   }
// }

class AbilityCard extends StatelessWidget {
  final Ability ability;

  AbilityCard({@required this.ability});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          PokemonAttribute(name: "Name", value: ability.name ?? ''),
          PokemonAttribute(
              name: "Accuracy", value: '${ability.accuracy}' ?? ''),
          PokemonAttribute(name: "Power", value: '${ability.power}' ?? ''),
          PokemonAttribute(name: "Type", value: ability.type) ?? '',
          PokemonAttribute(
              name: "Damage class", value: ability.damageClass ?? ''),
          // SizedBox(
          //   height: 5,
          // ),
          Text(ability.description ?? '')
        ],
      ),
    );
  }
}
