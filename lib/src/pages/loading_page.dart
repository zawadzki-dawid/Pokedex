import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

// Utils
import 'package:pokedex/src/utils/api/poke_api.dart';
import 'package:pokedex/src/utils/models/pokemon.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  void fetchAllPokemons() async {
    List<Pokemon> pokemons = List<Pokemon>();
    PokeApi api = PokeApi();
    try {
      Response pokesRes = await api.getAllPokemons();
      Map pokemonsData = jsonDecode(pokesRes.body);
      pokemonsData['results'].forEach((element) async {
        String name = element['name'];
        Response pokeRes = await api.getSpecificPokemonByName(name);
        Map pokemonData = jsonDecode(pokeRes.body);
        String imageUrl = pokemonData['sprites']['front_default'];
        pokemons.add(Pokemon(name: name, imageUrl: imageUrl));
      });
    } catch(err) {
      print('err');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
