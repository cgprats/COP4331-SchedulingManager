import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/utils/global_data.dart';
import 'package:mobile/components/sign_up_or_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.grey,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGN IN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: _size.height * 0.03,
              ),
              _MainPage(),
              SignUpOrLogin(
                login: true,
              ),
            ],
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
  static final _formKey = GlobalKey<FormState>();
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
              _payload['login'] = text;
            },
            width: _size.width * 0.8,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
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
            autofocus: true,
            onFieldSubmitted: (text) {},
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
          _errorMessage =
              jsonObj['error'].startsWith('Success: ') ? '' : jsonObj['error'];
          GlobalData.firstName = jsonObj['firstName'];
          GlobalData.lastName = jsonObj['lastName'];
        },
      );
    }
  }
}
