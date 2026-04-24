import 'package:flutter/material.dart';
import 'package:rickandmorty/application/di/app_bindings.dart';
import 'package:rickandmorty/application/app_widget.dart';

void main() {
  AppBindings.setup();
  runApp(const MyApp());
}
