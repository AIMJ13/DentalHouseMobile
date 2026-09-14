import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DentalHouse',
      theme: ThemeData(
        fontFamily: 'Outfit',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: Routes.login,
      routes: Routes.routes,
    );
  }
}
