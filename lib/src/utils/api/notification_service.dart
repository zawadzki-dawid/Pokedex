import 'package:flutter/material.dart';

import '../models/memory_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pokedex/src/utils/models/navigation_service.dart';
import '../../locator.dart';

class PushNotificationService {
  final FirebaseMessaging _firebase_messaging = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();
  MemoryHandler memoryHandler;

  PushNotificationService() {
    memoryHandler = new MemoryHandler();
  }

  Future _serialiseAndNavigate(Map<String, dynamic> message) async {
     //final int index = await memoryHandler.drawAndDeleteIndex();
    _navigationService.navigateTo("wiki-page", {'id': 1});
  }

  Future initialize() async {
    _firebase_messaging.configure(
      onResume: _serialiseAndNavigate,
      onLaunch: _serialiseAndNavigate
      );


    }
  }