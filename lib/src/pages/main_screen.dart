import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../locator.dart';
import '../utils/app_icons.dart';
import '../utils/models/custom_icon.dart';
import '../utils/models/navigation_service.dart';
import '../utils/models/pokemon.dart';
import '../utils/extensions/string.dart';

var myIcons = <String, CustomIcon>{
  'fire': CustomIcon(iconData: AppIcons.fire, color: Colors.red),
  'grass': CustomIcon(iconData: AppIcons.grass, color: Colors.green),
  'water': CustomIcon(iconData: AppIcons.water_drop, color: Colors.blue),
  'other': CustomIcon(iconData: AppIcons.question, color: Colors.black),
};

class MainScreen extends StatefulWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  final Function getDataFunction;

  MainScreen({@required this.getDataFunction});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController editingController = TextEditingController();
  var items = List<Pokemon>();
  var filteredItems = List<Pokemon>();
  String searchValue = "";
  bool loading = true;

  List<String> countList = ["Fire", "Water", "Grass", "Other"];
  List<String> selectedCountList = [];

  void _openFilterDialog() async {
    Color color = Colors.red;
    await FilterListDialog.display(context,
        hideSearchField: true,
        allTextList: countList,
        height: 200,
        borderRadius: 5,
        closeIconColor: color,
        headerTextColor: color,
        applyButonTextBackgroundColor: color,
        allResetButonColor: color,
        selectedTextBackgroundColor: color,
        unselectedTextbackGroundColor: Colors.grey.withOpacity(0.1),
        headlineText: "Filter by type",
        hideSelectedTextCount: true,
        hidecloseIcon: true,
        searchFieldHintText: "Search Here",
        selectedTextList: selectedCountList, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          selectedCountList = List.from(list);
        });
      }
      Navigator.pop(context);
    });
  }

  void loadData() async {
    dynamic url = "https://pokeapi.co/api/v2/pokemon";
    while(url != null) {
      dynamic data = await widget.getDataFunction(url);
      setState(() {
        items.addAll(data["pokemons"]);
      });
      url = data["next"];
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void filterSearchResults(String query) {
    setState(() {
      searchValue = query;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No', style: TextStyle(color: Colors.red[300]))),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes', style: TextStyle(color: Colors.red[300]))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    filteredItems = items.where((item) => item.name.toLowerCase().startsWith(searchValue.toLowerCase())).toList();
    filteredItems = filteredItems.where((item) {
      if(selectedCountList.isEmpty) {
        return true;
      }
      if(selectedCountList.contains(item.type.capitalize())) {
        return true;
      }
      return false;
    }).toList();

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Pokedex"),
          backgroundColor: Colors.red[300],
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () async {
                  String photoScanResult = await scanner.scan();
                  try {
                    await widget._navigationService
                        .navigateTo('wiki-page', int.parse(photoScanResult));
                  } catch (err) {}
                })
          ],
        ),
        body: items.isEmpty
            ? SpinKitRing(
                color: Colors.red[300],
                size: 50.0,
              )
            : WillPopScope(
                onWillPop: _onBackPressed,
                child: Container(
                  margin: new EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  filterSearchResults(value);
                                },
                                controller: editingController,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.withOpacity(0.2),
                                    filled: true,
                                    // labelText: "Search",
                                    hintText: "Search",
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.red[300],
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)))),
                              ),
                            ),
                          ),
                          Expanded(
                              child: IconButton(
                            onPressed: _openFilterDialog,
                            tooltip: 'Increment',
                            icon: Icon(Icons.filter, color: Colors.red),
                          ))
                          // Icon(Icons.filter, color: Colors.red[300]))),
                        ],
                      ),
                      Expanded(
                        child: CustomScrollView(
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 4 / 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0),
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                              return GestureDetector(
                                child: new Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    // color: Colors.redAccent,
                                    child: PokemonCard(pokemon: filteredItems[index])),
                                onTap: () async {
                                  await widget._navigationService
                                      .navigateTo('wiki-page', filteredItems[index].id);
                                },
                              );
                            },
                              childCount: filteredItems.length,

                            )
                          ),
                          SliverToBoxAdapter(
                            child: loading ?
                              Container(
                                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  child: SpinKitRing(
                              color: Colors.red[300],
                              size: 50.0,
                            )
                          ) : null
                              )
                      ])
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class PokemonCard extends StatelessWidget {
  PokemonCard({this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    String type = pokemon.type;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
              child: Icon(
                myIcons[type].iconData,
                color: myIcons[type].color,
              ),
            ),
          ],
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 1, child: Image.network(pokemon.imageUrl)),
              Expanded(
                  flex: 1,
                  child: Center(child: Text(pokemon.name.capitalize()))),
            ],
          ),
        ),
      ]),
    );
  }
}
