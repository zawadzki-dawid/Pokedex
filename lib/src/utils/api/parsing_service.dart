import 'dart:convert';

import 'package:http/http.dart';
import 'package:pokedex/src/utils/api/poke_api.dart';
import 'package:pokedex/src/utils/models/pokemon.dart';

class DataService {
  static Future<Object> getAllPokemons(String url) async {
    List<Pokemon> pokemons = List<Pokemon>();
    Map pokemonsData;
    try {
      Response pokemonsResponse = await PokeApi.getPokemonsFromCustomURL(url);
      pokemonsData = jsonDecode(pokemonsResponse.body);
      for (var element in pokemonsData['results']) {
        String name = element['name'];
        Response pokemonsResponse =
            await PokeApi.getSpecificPokemonByName(name);
        Map pokemonData = jsonDecode(pokemonsResponse.body);
        String imageUrl = pokemonData['sprites']['front_default'];
        int id = pokemonData['id'];
        String type = pokemonData['types'][0]['type']['name'];
        if (type != "fire" && type != "water" && type != "grass") {
          type = "other";
        }
        pokemons.add(Pokemon(id: id, name: name, type: type, imageUrl: imageUrl));
      }
    } catch (e, s) {
      print('$e: $s');
      rethrow;
    }
    return {
      "pokemons": pokemons,
      "next": pokemonsData['next']
    };
    }
  }

