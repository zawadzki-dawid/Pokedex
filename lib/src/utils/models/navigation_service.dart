import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateToReplace(String routeName, Object args) {
    return navigatorKey.currentState.pushReplacementNamed(routeName, arguments: args);
  }

  Future<dynamic> navigateTo(String routeName, Object args) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: args);
  }

}