import 'package:flutter/material.dart';
import '../utils/models/pokemon.dart';
import '../utils/models/navigation_service.dart';
import '../locator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
    if (query.isNotEmpty) {
      List<Pokemon> dummyListData = List<Pokemon>();
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
    } else {
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
          content: Text('You\'re going to exit the application'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No')
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes')
            ),
          ],
        );
      }
    );
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
      body: duplicateItems.isEmpty?
      SpinKitRing(
        color: Colors.red[300],
        size: 50.0,
      )
          :
      WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 5 / 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: new Card(
                          color: Colors.redAccent,
                          child: PokemonCard(pokemon: items[index])
                      ),
                      onTap: () async {
                        await widget._navigationService.navigateTo('wiki-page', {'id': items[index].id});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        )
    );
  }
}


class PokemonCard extends StatelessWidget {
  PokemonCard({this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    // print(pokemon.name);
    return Container(
      child: Row(
        children: [
          Image.network(pokemon.imageUrl),
          Text(capitalize(pokemon.name)),
        ],
      ),
    );
  }
}

