import 'package:flutter/material.dart';

import 'package:mobile/screens/sign_up_screen.dart';
import 'package:mobile/screens/job_listings_screen.dart';

class Routes {
  static const String SIGNUPSCREEN = '/signup';
  static const String JOBLISTINGSSCREEN = '/joblistings';

  static Map<String, Widget Function(BuildContext)> get getRoutes => {
    '/': (context) => JobListingsScreen(),//SignUpScreen(),
    SIGNUPSCREEN: (context) => SignUpScreen(),
    JOBLISTINGSSCREEN: (context) => JobListingsScreen(),
  };
}