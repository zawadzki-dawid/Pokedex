import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class MemoryHandler {
  List<int> pokemonIndexes;

  MemoryHandler() {
    pokemonIndexes = new List<int>();
    readPokemonIndexes();
  }

  Future readPokemonIndexes() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final pokemonIndexesString = sharedPreferences.getStringList('pokemonIndexesString') ?? [];
    List<int> pokemonIndexesInt = new List<int>();
    if(pokemonIndexesString.isEmpty == true) {
      for(int i = 1; i <= 1000; i++) {
        pokemonIndexesInt.add(i);
      }
      sharedPreferences.setStringList('pokemonIndexesString', pokemonIndexesInt.map((el) => el.toString()).toList());
      pokemonIndexes = List.from(pokemonIndexesInt);
      return;
    }
    pokemonIndexesInt = List.from(pokemonIndexesString.map((i) => int.parse(i)).toList());
    pokemonIndexes = List.from(pokemonIndexesInt);
    return;
  }

  Future<int> drawAndDeleteIndex() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    int numOfIndexes = pokemonIndexes.length;
    Random random = new Random();
    int randomValue = random.nextInt(numOfIndexes);
    int pokemonIndexAtRandom = pokemonIndexes[randomValue];
    pokemonIndexes.removeAt(randomValue);
    sharedPreferences.setStringList('pokemonIndexesString', pokemonIndexes.map((el) => el.toString()).toList());
    return pokemonIndexAtRandom;
  }
}