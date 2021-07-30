import 'package:flutter/material.dart';
import 'package:mobile/screens/login_screen.dart';

import 'routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app title goes here',
      home: LoginScreen(),
      routes: Routes.getRoutes,
    );
  }
}