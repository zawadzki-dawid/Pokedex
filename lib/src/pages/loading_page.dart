import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final Function getDataFunction;
  final String nextRoute;

  LoadingPage({@required this.getDataFunction, @required this.nextRoute});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void loadData() async {
    dynamic data = await widget.getDataFunction();
    Navigator.pushReplacementNamed(context, widget.nextRoute,
        arguments: {'loadedData': data});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
