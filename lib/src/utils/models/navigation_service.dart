import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, Object args) {
    return navigatorKey.currentState.pushReplacementNamed(routeName, arguments: args);
  }
}