import 'package:pokedex/src/utils/models/ability.dart';

class Pokemon {
  int id;
  String name;
  String imageUrl;
  String type;
  int weight;
  int height;
  List<Ability> abilities = [];
  bool finalEvolution;

  Pokemon(
      {this.id,
      this.name = '',
      this.imageUrl,
      this.type = '',
      this.weight,
      this.height,
      this.abilities = const [],
      this.finalEvolution});
}
