import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/custom_scaffold.dart';
import 'package:mobile/components/textfield_widget.dart';
import 'package:mobile/components/rounded_input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isBack = true;
  double angle = 0;
  String errorMessage = '';

  Map verify_payload = {
    'email': '',
  };
  Map changepassword_payload = {
    'email': '',
    'ver': '',
    'new_password': '',
    'new_password_confirm': '',
  };

  String _errorMessage = '';

  void flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: angle),
                    duration: Duration(milliseconds: 500),
                    builder: (BuildContext context, double val, _) {
                      if (val >= (pi / 2)) {
                        isBack = false;
                      } else {
                        isBack = true;
                      }
                      return (Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(val),
                        child: Container(
                            width: 320,
                            height: 450,
                            child: isBack
                                ? Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: CustomColors.grey,
                                    ),
                                    child: Column(children: <Widget>[
                                      Text(
                                        "Reset your password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      RoundedInputField(
                                        labelText: 'Email',
                                        hintText: 'example@email.com',
                                        width: _size.width * 0.6,
                                        onChanged: (text) {
                                          verify_payload['email'] = text;
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RoundedButton(
                                        text: 'Confirm',
                                        color: CustomColors.orange,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        onPressed: () {
                                          _verify();
                                          flip();
                                        },
                                      ),
                                    ]),
                                  )
                                : Transform(
                                    transform: Matrix4.identity()..rotateY(pi),
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: CustomColors.grey,
                                      ),
                                      child: Column(children: <Widget>[
                                        Text(
                                          "Reset Password",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        RoundedInputField(
                                          labelText: 'Verification Code',
                                          width: _size.width * 0.6,
                                          onChanged: (text) {
                                            changepassword_payload['ver'] =
                                                text;
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        RoundedInputField(
                                          labelText: 'New Password',
                                          width: _size.width * 0.6,
                                          onChanged: (text) {
                                            changepassword_payload[
                                                'new_password'] = text;
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        RoundedInputField(
                                          labelText: 'Confirm New Password',
                                          width: _size.width * 0.6,
                                          onChanged: (text) {
                                            changepassword_payload[
                                                'new_password_confirm'] = text;
                                          },
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Visibility(
                                          visible: errorMessage.isNotEmpty,
                                          child: Text(
                                            errorMessage,
                                            style: TextStyle(
                                              color: CustomColors.orange,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              RoundedButton(
                                                text: 'Confirm',
                                                color: CustomColors.orange,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                                onPressed: () {
                                                  changepassword_payload[
                                                          'email'] =
                                                      verify_payload['email'];
                                                  _changePassword();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  )),
                      ));
                    })
              ],
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: CustomColors.purple,
        ),
      ),
    );
  }

  void _changePassword() async {
    print('changing password!');
    String dir = '/changepassword';
    String ret = await API.getJson(dir, changepassword_payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    errorMessage = jsonObj['error'];
    setState(
      () {
        if (!errorMessage.startsWith("Verification code invalid")) {
          errorMessage = '';
          Navigator.pop(context);
          flip();
        }
      },
    );
  }

  void _verify() async {
    print('verifying!');
    String dir = '/sendcode';
    String ret = await API.getJson(dir, verify_payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
  }
}
