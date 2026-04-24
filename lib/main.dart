import 'package:flutter/material.dart';
import 'package:rickandmorty/application/di/app_bindings.dart';
import 'package:rickandmorty/application/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBindings.setup();
  runApp(const MyApp());
}
