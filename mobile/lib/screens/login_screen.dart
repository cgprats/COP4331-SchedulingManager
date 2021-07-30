import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/utils/global_data.dart';
import 'package:mobile/components/sign_up_or_login.dart';
import 'package:mobile/components/custom_scaffold.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return CustomScaffold(
      title: 'Sign In',
      appBarColor: CustomColors.orange,
      backgroundColor: CustomColors.purple,
      body: Center(
        child: SingleChildScrollView(
          // padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                _MainPage(),
                SignUpOrLogin(
                  login: true,
                ),
                SizedBox(
                  height: _size.height * 0.01,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/forgotpassword',
                      );
                    },
                    child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                        )
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map _payload = Map();
  bool _visible = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          RoundedInputField(
            order: 1,
            labelText: 'Email',
            hintText: 'example@email.com',
            onChanged: (text) {
              _payload['email'] = text;
            },
            width: _size.width * 0.8,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            // autofocus: true,
          ),
          RoundedInputField(
            order: 2,
            labelText: 'Password',
            hintText: 'Password',
            onChanged: (text) {
              _payload['password'] = text;
            },
            obscureText: !_visible,
            width: _size.width * 0.8,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (text) {
              if (_formKey.currentState!.validate()) {
                _login(_payload);
              }
            },
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              icon: Icon(
                _visible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              },
            ),
          ),
          Visibility(
            visible: _errorMessage.isNotEmpty,
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: CustomColors.orange,
                fontSize: 16,
              ),
            ),
          ),
          RoundedButton(
            text: 'SIGN IN',
            width: _size.width * 0.8,
            fontSize: 20,
            color: CustomColors.orange,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _login(_payload);
              }
            },
          ),
        ],
      ),
    );
  }

  void _login(Map _payload) async {
    print('login!');
    String dir = '/login';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
            () {
          _errorMessage = jsonObj['error'];
          if (_errorMessage.startsWith('Success: ')) {
            print('login successful!');
            _errorMessage = '';
            GlobalData.firstName = jsonObj['firstName'];
            GlobalData.lastName = jsonObj['lastName'];
            GlobalData.phone = jsonObj['phone'];
            GlobalData.email = jsonObj['email'];
            GlobalData.accountType = jsonObj['flag'];
            GlobalData.companyCode = jsonObj['companyCode'];
            GlobalData.companyName = jsonObj['companyName'];
            GlobalData.verified = jsonObj['Verified'];
            //TODO: add if verified check
            Navigator.pushNamed(context, Routes.JOBLISTINGSSCREEN);
          }
        },
      );
    }
  }
}
