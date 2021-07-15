import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/CustomColors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    // MediaQueryData mq = MediaQuery.of(context);
    // Size size = Size(
    //   mq.size.width,
    //   mq.size.height - mq.viewInsets.vertical - mq.viewPadding.vertical - mq.padding.vertical,
    // );
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign Up'),
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Container(
          // height: size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _AccountTypeSelector(),
              Text(
                "SIGN UP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: _size.height * 0.05,
              ),
              _SignUpForm(),
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.grey,
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  Map _payload = Map();
  bool _visible1 = false, _visible2 = false;
  String _errorMessage = 's';

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    _payload['flag'] = 0;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          RoundedInputField(
            labelText: 'First Name',
            hintText: 'John',
            width: _size.width * 0.8,
            onChanged: (text) {
              _payload['firstName'] = text;
            },
            autofocus: true,
          ),
          RoundedInputField(
            labelText: 'Last Name',
            hintText: 'Doe',
            width: _size.width * 0.8,
            onChanged: (text) {
              _payload['lastName'] = text;
            },
          ),
          RoundedInputField(
            labelText: 'Email',
            hintText: 'john.doe@email.com',
            width: _size.width * 0.8,
            onChanged: (text) {
              _payload['email'] = text;
            },
          ),
          RoundedInputField(
            labelText: 'Phone Number',
            hintText: '(123) 456-7890',
            width: _size.width * 0.8,
            onChanged: (text) {
              _payload['phone'] = text;
            },
          ),
          RoundedInputField(
            labelText: 'Company ' +
                () {
                  if (_payload['flag'] == 1)
                    return 'Name';
                  else
                    return 'Code';
                }(),
            hintText: '1234',
            width: _size.width * 0.8,
            onChanged: (text) {
              if (_payload['flag'] == 1)
                _payload['companyName'] = text;
              else
                _payload['companyCode'] = text;
            },
          ),
          RoundedInputField(
            labelText: 'Password',
            hintText: 'Password',
            obscureText: !_visible1,
            width: _size.width * 0.8,
            onChanged: (text) {
              _payload['password'] = text;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _visible1 ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _visible1 = !_visible1;
                });
              },
            ),
          ),
          RoundedInputField(
            labelText: 'Confirm Password',
            hintText: 'Confirm Password',
            obscureText: !_visible2,
            width: _size.width * 0.8,
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              _payload['password_confirm'] = text;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _visible2 ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _visible2 = !_visible2;
                });
              },
            ),
            onFieldSubmitted: (text) {
              if (_formKey.currentState!.validate()) {
                _register(_payload);
              }
            },
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
            text: 'Sign Up',
            width: _size.width * 0.8,
            color: _payload['flag'] == 1
                ? CustomColors.green
                : CustomColors.purple,
            onPress: () {
              if (_formKey.currentState!.validate()) {
                _register(_payload);
              }
            },
          ),
        ],
      ),
    );
  }

  void _register(Map _payload) async {
    String dir = '/register';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
        () {
          _errorMessage =
              jsonObj['error'].startsWith('Success: ') ? '' : jsonObj['error'];
        },
      );
    }
  }
}

class _AccountTypeSelector extends StatefulWidget {
  @override
  _AccountTypeSelectorState createState() => _AccountTypeSelectorState();
}

class _AccountTypeSelectorState extends State<_AccountTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}