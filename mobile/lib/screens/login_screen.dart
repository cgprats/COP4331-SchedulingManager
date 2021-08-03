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
                Image(
                  image: AssetImage('assets/logo.png'),
                  width: _size.width * 0.8,
                ),
                Text(
                  'WORKHORSE',
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MainPage(),
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
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: CustomColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _curve;
  late Animation<double> _textFieldAnimation;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map _payload = Map();
  bool _visible = false;
  bool _needVerification = GlobalData.verified == false;
  // _needVerification logic might seem redundant,
  // but it is used so null is false
  String verificationCode = '';
  String _errorMessage = '';

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _textFieldAnimation = Tween(begin: 0.0, end: 1.0).animate(_curve);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_needVerification) _animationController.forward();
    Size _size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          RoundedInputField(
            order: 1,
            labelText: 'Email',
            hintText: 'example@email.com',
            width: _size.width * 0.8,
            keyboardType: TextInputType.emailAddress,
            labelColor: CustomColors.orange,
            onChanged: (text) {
              _payload['email'] = text;
            },
          ),
          RoundedInputField(
            order: 2,
            labelText: 'Password',
            hintText: 'Password',
            obscureText: !_visible,
            width: _size.width * 0.8,
            keyboardType: TextInputType.visiblePassword,
            labelColor: CustomColors.orange,
            textInputAction: _needVerification ? TextInputAction.next : TextInputAction.done,
            onChanged: (text) {
              _payload['password'] = text;
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
            onFieldSubmitted: (text) {
              if (!_needVerification && _formKey.currentState!.validate()) {
                login(_payload);
              }
            },
          ),
          SizeTransition(
            sizeFactor: _textFieldAnimation,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: Center(
              child: RoundedInputField(
                order: 3,
                skipTraversal: !_needVerification,
                enabled: _needVerification,
                required: _needVerification,
                labelText: 'Verification Code',
                hintText: '1234',
                width: _size.width * 0.8,
                keyboardType: TextInputType.number,
                labelColor: CustomColors.orange,
                onChanged: (text) {
                  // if (text.isEmpty) text = '0';
                  verificationCode = text;
                },
                onFieldSubmitted: (text) {
                  if (_formKey.currentState!.validate()) {
                    login(_payload);
                  }
                },
              ),
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
                login(_payload);
              }
            },
          ),
        ],
      ),
    );
  }

  void login(Map _payload) async {
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
            GlobalData.verified = jsonObj['verified'];
            if (_needVerification) {
              _verify({
                'email': jsonObj['email'],
                'verificationCode': verificationCode,
              });
            } else {
              if (GlobalData.verified == true) {
                Navigator.pushNamed(context, Routes.JOBLISTINGSSCREEN);
              } else {
                _needVerification = true;
              }
            }
          }
        },
      );
    }
  }

  void _verify(Map _payload) async {
    print('verify!');
    String dir = '/verify';
    print(_payload);
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
          if (_errorMessage.isEmpty) {
            print('verify successful!');
            _errorMessage = '';
            GlobalData.verified = true;
            Navigator.pushNamed(context, Routes.JOBLISTINGSSCREEN);
          }
        },
      );
    }
  }
}
