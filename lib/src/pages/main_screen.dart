import 'package:flutter/material.dart';
import '../utils/models/pokemon.dart';
import '../utils/models/navigation_service.dart';
import '../locator.dart';
import '../utils/app_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/models/custom_icon.dart';
import 'package:filter_list/filter_list.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
  var duplicateItems = List<Pokemon>();
  var items = List<Pokemon>();
  String searchValue = "";

  List<String> countList = [
    "Fire",
    "Water",
    "Grass",
    "Other"
  ];
  List<String> selectedCountList = [];

  void _openFilterDialog() async {
    Color color = Colors.red;
    await FilterListDialog.display(
        context,
        hideSearchField: true,
        allTextList: countList,
        height: 200,
        borderRadius: 5,
        closeIconColor: color,
        headerTextColor : color,
        applyButonTextBackgroundColor : color,
        allResetButonColor : color,
        selectedTextBackgroundColor : color,
        headlineText: "Select Count",
        searchFieldHintText: "Search Here",
        selectedTextList: selectedCountList,
        onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              selectedCountList = List.from(list);
              print(selectedCountList);
              filterSearchResults(searchValue);
            });
          }
          Navigator.pop(context);
        });
  }

  void loadData() async {
    dynamic data = await widget.getDataFunction();
    setState(() {
      duplicateItems.addAll(data);
    });
  }

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
    loadData();
  }

  void filterSearchResults(String query) {
    searchValue = query;
    List<Pokemon> dummySearchList = List<Pokemon>();
    dummySearchList.addAll(duplicateItems);
    List<Pokemon> dummyListData = List<Pokemon>();
    if (query.isNotEmpty && selectedCountList.isNotEmpty) {
      dummySearchList.forEach((item) {
        if (item.name.contains(query) && selectedCountList.contains(capitalize(item.type))) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    }
    else if(query.isNotEmpty && selectedCountList.isEmpty){
      dummySearchList.forEach((item) {
        if (item.name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    }

    else if(query.isEmpty && selectedCountList.isNotEmpty){
      dummySearchList.forEach((item) {
        if (selectedCountList.contains(capitalize(item.type))) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    }
    else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
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
    if (items.isEmpty && searchValue == "") {
      items.addAll(duplicateItems);
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Pokedex"),
          backgroundColor: Colors.red[300],
        ),
        body: duplicateItems.isEmpty
            ? SpinKitRing(
          color: Colors.red[300],
          size: 50.0,
        )
            : WillPopScope(
          onWillPop: _onBackPressed,
          child: Container(
            margin: new EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                                vertical: 10.0,
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
                    SizedBox(
                        width: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FloatingActionButton(
                            onPressed: _openFilterDialog,
                            tooltip: 'Increment',
                            child: Icon(Icons.filter, color: Colors.white),
                            backgroundColor: Colors.red[300],
                          ),
                        )
                    )
                    // Icon(Icons.filter, color: Colors.red[300]))),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: new Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            // color: Colors.redAccent,
                            child: PokemonCard(pokemon: items[index])),
                        onTap: () async {
                          await widget._navigationService.navigateTo(
                              'wiki-page', {'id': items[index].id});
                        },
                      );
                    },
                  ),
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
    // if (type != "fire" && type != "water" && type != "grass") {
    //   type = "other";
    // }
    // print(pokemon.name);
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),

      // column of three rows
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            // Text(capitalize(type)),
            Padding(
                padding: EdgeInsets.fromLTRB(150, 15, 0, 0),
                child: Icon(
                  myIcons[type].iconData,
                  color: myIcons[type].color,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(pokemon.imageUrl),
            Text(capitalize(pokemon.name)),
          ],
        ),
      ]),
    );
  }
}
