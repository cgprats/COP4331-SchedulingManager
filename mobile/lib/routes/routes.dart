import 'package:flutter/material.dart';

import 'package:mobile/screens/sign_up_screen.dart';

class Routes {
  static const String SIGNUPSCREEN = '/signup';

  static Map<String, Widget Function(BuildContext)> get getRoutes => {
    '/': (context) => SignUpScreen(),
    SIGNUPSCREEN: (context) => SignUpScreen(),
  };
}