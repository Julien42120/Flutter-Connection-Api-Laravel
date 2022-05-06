import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_connexion_laravel/services/property_service.dart';
import 'package:flutter_connexion_laravel/views/property_list.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => PropertiesService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PropertyList(),
    );
  }
}
