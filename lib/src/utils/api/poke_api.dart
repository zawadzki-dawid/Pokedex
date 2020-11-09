import 'package:http/http.dart';

class PokeApi {
  String mainUrl = 'https://pokeapi.co/api/v2/pokemon?limit=10';
  String pokemonUrl = 'https://pokeapi.co/api/v2/pokemon/';
  String evolutionUrl = 'https://pokeapi.co/api/v2/evolution-chain/';
  String locationUrl = 'https://pokeapi.co/api/v2/location/';
  String moveUrl = 'https://pokeapi.co/api/v2/move/';

  Future<Response> getAllPokemons() async {
    return await get(mainUrl);
  }

  Future<Response> getSpecificPokemonById(int idx) async {
    return await get(pokemonUrl + idx.toString());
  }

  Future<Response> getSpecificPokemonByName(String name) async {
    return await get(pokemonUrl + name);
  }

  Future<Response> getPokemonLocationsById(int idx) async {
    return await get(locationUrl + idx.toString());
  }

  Future<Response> getPokemonLocationsByName(String name) async {
    return await get(locationUrl + name);
  }

  Future<Response> getPokemonMovesById(int idx) async {
    return await get(moveUrl + idx.toString());
  }

  Future<Response> getPokemonMovesByName(String name) async {
    return await get(moveUrl + name);
  }

  Future<Response> getPokemonEvolution(int idx) async {
    return await get(evolutionUrl + idx.toString());
  }

}