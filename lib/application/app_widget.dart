import 'package:flutter/material.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/shared/shared.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rick and Morty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
