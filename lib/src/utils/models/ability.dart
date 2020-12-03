class Ability {
  int id;
  String name;
  int accuracy = 0;
  int power = 0;
  String type;
  String damageClass;
  String description;

  Ability(
      {this.id,
      this.name = '',
      this.accuracy,
      this.power,
      this.type = '',
      this.damageClass = '',
      this.description = ''});
}
