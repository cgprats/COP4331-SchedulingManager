import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';

class SignUpOrLogin extends StatelessWidget {
  final bool login;

  const SignUpOrLogin({
    this.login = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          color: CustomColors.white,
          indent: 20,
          endIndent: 20,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              this.login
                  ? "Don't have an Account? "
                  : "Already have an Account? ",
              style: TextStyle(
                color: CustomColors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  this.login ? '/signup' : '/login',
                );
              },
              child: Text(
                this.login ? 'Sign Up!' : 'Sign In!',
                style: TextStyle(
                  color: CustomColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
