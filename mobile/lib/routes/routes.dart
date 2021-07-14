import 'package:flutter/material.dart';

import 'package:large_project/screens/SignUpScreen.dart';

class Routes {
  static const String SIGNUPSCREEN = '/signup';

  static Map<String, Widget Function(BuildContext)> get getRoutes => {
    '/': (context) => SignUpScreen(),
    SIGNUPSCREEN: (context) => SignUpScreen(),
  };
}