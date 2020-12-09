import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pokedex/src/utils/api/poke_api.dart';
import 'package:pokedex/src/utils/extensions/string.dart';
import 'package:pokedex/src/utils/models/ability.dart';
import 'package:pokedex/src/utils/models/navigation_service.dart';
import 'package:pokedex/src/utils/models/pokemon.dart';
import '../utils/models/memory_handler.dart';

import '../locator.dart';

class WikiPage extends StatefulWidget {
  int id; // Pokemon's ID in PokeApi
  final MemoryHandler _memoryHandler = new MemoryHandler();
  WikiPage({@required this.id});

  @override
  _WikiPageState createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  Pokemon pokemon;
  Pokemon nextEvolution;

  _WikiPageState() {
    pokemon = Pokemon();
    nextEvolution = Pokemon();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    if(widget.id == 0) {
      widget.id = await widget._memoryHandler.drawAndDeleteIndex();
    }
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
      int englishDescriptionIndex = -1;
      List descriptionList = moveData["flavor_text_entries"];
      for (int i = 0; i < descriptionList.length; ++i) {
        if (descriptionList[i]["language"]["name"] == "en") {
          englishDescriptionIndex = i;
          break;
        }
      }
      if (englishDescriptionIndex == -1) {
        englishDescriptionIndex = 0;
      }
      Ability ability = new Ability(
          id: moveData["id"],
          name: moveData["name"],
          accuracy: moveData["accuracy"],
          power: moveData["power"],
          type: moveData["type"]["name"],
          damageClass: moveData["damage_class"]["name"],
          description: moveData["flavor_text_entries"][englishDescriptionIndex]
              ["flavor_text"]);
      setState(() {
        pokemon.abilities.add(ability);
      });
    }

    String speciesUrl = pokemonData["species"]["url"];
    Response speciesResponseData = await get(speciesUrl);
    Map speciesData = jsonDecode(speciesResponseData.body);
    String speciesName = speciesData["name"];
    String evolutionChainUrl = speciesData["evolution_chain"]["url"];
    Response evolutionChainResponseData = await get(evolutionChainUrl);
    Map evolutionChainData = jsonDecode(evolutionChainResponseData.body);

    Map currentChainLevel = evolutionChainData["chain"];
    while (speciesName != currentChainLevel["species"]["name"]) {
      currentChainLevel = currentChainLevel["evolves_to"][0];
    }
    List evolutionChainLevelList = currentChainLevel["evolves_to"];
    if (evolutionChainLevelList == null || evolutionChainLevelList.isEmpty) {
      setState(() {
        nextEvolution.finalEvolution = true;
      });
    } else {
      String evolutionSpeciesUrl = evolutionChainLevelList[0]["species"]["url"];
      Response evolutionSpeciesResponseData = await get(evolutionSpeciesUrl);
      Map evolutionsSpeciesData = jsonDecode(evolutionSpeciesResponseData.body);
      String evolutionPokemonUrl =
          evolutionsSpeciesData["varieties"][0]["pokemon"]["url"];
      Response evolutionPokemonResponseData = await get(evolutionPokemonUrl);
      Map evolutionPokemonData = jsonDecode(evolutionPokemonResponseData.body);
      setState(() {
        nextEvolution.id = evolutionPokemonData["id"];
        nextEvolution.name = evolutionPokemonData["name"];
        nextEvolution.imageUrl =
            evolutionPokemonData["sprites"]["front_default"];
        nextEvolution.finalEvolution = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    String title = pokemon != null ? pokemon.name.capitalize() : '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(title),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Basic information',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: BasicInfoCard(
              pokemon: pokemon,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Stack(alignment: Alignment.center, children: [
                  Center(
                    child: Text(
                      'Abilities',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                          ),
                          onPressed: () {
                            controller.animateToPage(
                                controller.page.toInt() - 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          }),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            controller.animateToPage(
                                controller.page.toInt() + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          }),
                    ],
                  )
                ]),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
              height: 300,
              child: PageView.builder(
                controller: controller,
                itemBuilder: (context, position) {
                  return AbilityCard(ability: pokemon.abilities[position]);
                },
                itemCount: pokemon.abilities.length, // Can be null
              )),
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Evolution',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: EvolutionCard(pokemon: nextEvolution),
          )
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
      elevation: 3,
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
            flex: 5,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 8, 16, 8),
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
                Text(
                  value.capitalize(),
                  style: TextStyle(
                    color: Colors.black,
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

class AbilityCard extends StatelessWidget {
  final Ability ability;

  AbilityCard({@required this.ability});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: PokemonAttribute(
                    name: "Name", value: ability.name ?? 'Unknown')),
            Flexible(
              child: PokemonAttribute(
                  name: "Accuracy", value: '${ability.accuracy ?? 'Unknown'}'),
            ),
            Flexible(
              child: PokemonAttribute(
                  name: "Power", value: '${ability.power ?? 'Unknown'}'),
            ),
            Flexible(
                child: PokemonAttribute(name: "Type", value: ability.type) ??
                    'Unknown'),
            Flexible(
              child: PokemonAttribute(
                  name: "Damage class",
                  value: ability.damageClass ?? 'Unknown'),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    ability.description
                            .replaceAllMapped('\n', (match) => ' ') ??
                        'Description unknown',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EvolutionCard extends StatelessWidget {
  final Pokemon pokemon;
  final NavigationService navigationService = locator<NavigationService>();

  EvolutionCard({@required this.pokemon});

  void showPokemonPage() async {
    await navigationService.navigateTo('wiki-page', pokemon.id);
  }

  void showToastEvolutionStillLoading() {
    Fluttertoast.showToast(
        msg: "Loading evolution...", toastLength: Toast.LENGTH_SHORT);
  }

  void showToastFinalEvolution() {
    Fluttertoast.showToast(
        msg: "Next evolution unavailable!", toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pokemon.finalEvolution != null
          ? (pokemon.finalEvolution ? showToastFinalEvolution : showPokemonPage)
          : showToastEvolutionStillLoading,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 3,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  pokemon.finalEvolution != null
                      ? (pokemon.finalEvolution
                          ? 'It is final evolution!'
                          : 'Evolves to: ${pokemon.name.capitalize()}')
                      : 'Evolution: loading...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Align(
                  child: AspectRatio(
                    aspectRatio: 3 / 1,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: pokemon.imageUrl != null
                                ? NetworkImage(
                                    pokemon.imageUrl,
                                  )
                                : AssetImage('lib/assets/pokeball.webp')),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
