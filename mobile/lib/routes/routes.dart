import 'package:flutter/material.dart';

import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/sign_up_screen.dart';
import 'package:mobile/screens/forgot_password_screen.dart';
import 'package:mobile/screens/job_listings_screen.dart';
import 'package:mobile/screens/employee_search_screen.dart';
import 'package:mobile/screens/manage_account.dart';

class Routes {
  static const String SIGNUPSCREEN = '/signup';
  static const String LOGINSCREEN = '/login';
  static const String FORGOTPASSWORDSCREEN = '/forgotpassword';
  static const String JOBLISTINGSSCREEN = '/jobListings';
  static const String MANAGEACCOUNTSCREEN = '/manageAccount';
  static const String EMPLOYEESEARCHSCREEN = '/employeeSearch';

  static Map<String, Widget Function(BuildContext)> get getRoutes => {
        // '/': (context) => LoginScreen(),
        LOGINSCREEN: (context) => LoginScreen(),
        SIGNUPSCREEN: (context) => SignUpScreen(),
        FORGOTPASSWORDSCREEN: (context) => ForgotPasswordScreen(),
        JOBLISTINGSSCREEN: (context) =>
            JobListingsScreen(GlobalKey<JobListingsScreenState>()),
        MANAGEACCOUNTSCREEN: (context) => ManageAccountScreen(),
        EMPLOYEESEARCHSCREEN: (context) =>
            EmployeeSearchScreen(GlobalKey<EmployeeSearchScreenState>()),
      };
}
