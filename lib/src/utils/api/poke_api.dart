import 'package:http/http.dart';

class PokeApi {
  static const String mainUrl =
      'https://pokeapi.co/api/v2/pokemon?limit=1000'; // TODO remove hardcoded limit
  static const String pokemonUrl = 'https://pokeapi.co/api/v2/pokemon/';
  static const String evolutionUrl =
      'https://pokeapi.co/api/v2/evolution-chain/';
  static const String locationUrl = 'https://pokeapi.co/api/v2/location/';
  static const String moveUrl = 'https://pokeapi.co/api/v2/move/';

  static Future<Response> getAllPokemons() async {
    return await get(mainUrl);
  }

  static Future<Response> getSpecificPokemonById(int id) async {
    return await get(pokemonUrl + id.toString());
  }

  static Future<Response> getSpecificPokemonByName(String name) async {
    return await get(pokemonUrl + name);
  }

  static Future<Response> getPokemonLocationsById(int id) async {
    return await get(locationUrl + id.toString());
  }

  static Future<Response> getPokemonLocationsByName(String name) async {
    return await get(locationUrl + name);
  }

  static Future<Response> getPokemonMovesById(int id) async {
    return await get(moveUrl + id.toString());
  }

  static Future<Response> getPokemonMovesByName(String name) async {
    return await get(moveUrl + name);
  }

  static Future<Response> getPokemonEvolution(int idx) async {
    return await get(evolutionUrl +
        idx.toString()); // TODO this gets wrong evolution (id is not for a pokemon)
  }
}