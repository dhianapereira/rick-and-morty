import 'package:flutter/material.dart';
import 'package:rickandmorty/presentation/home_page.dart';
import 'package:rickandmorty/shared/shared.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MyHomePage(),
    );
  }
}
