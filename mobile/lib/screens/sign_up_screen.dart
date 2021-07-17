import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGN UP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white,
                  fontSize: 30,
                ),
              ),
              _AccountTypeSelector(),
              SizedBox(
                height: _size.height * 0.03,
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
  static final _formKey = GlobalKey<FormState>();
  Map _payload = Map();
  bool _visible1 = false, _visible2 = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Column(
              children: <Widget>[
                RoundedInputField(
                  order: 1,
                  labelText: 'First Name',
                  hintText: 'John',
                  width: _size.width * 0.8,
                  labelColor: GlobalData.accountType == 1
                      ? CustomColors.green
                      : CustomColors.purple,
                  onChanged: (text) {
                    _payload['firstName'] = text;
                  },
                  autofocus: true,
                ),
                RoundedInputField(
                  order: 2,
                  labelText: 'Last Name',
                  hintText: 'Doe',
                  width: _size.width * 0.8,
                  labelColor: GlobalData.accountType == 1
                      ? CustomColors.green
                      : CustomColors.purple,
                  onChanged: (text) {
                    _payload['lastName'] = text;
                  },
                ),
                RoundedInputField(
                  order: 3,
                  labelText: 'Email',
                  hintText: 'john.doe@email.com',
                  width: _size.width * 0.8,
                  labelColor: GlobalData.accountType == 1
                      ? CustomColors.green
                      : CustomColors.purple,
                  onChanged: (text) {
                    _payload['email'] = text;
                  },
                ),
                RoundedInputField(
                  order: 4,
                  labelText: 'Phone Number',
                  hintText: '(123) 456-7890',
                  width: _size.width * 0.8,
                  labelColor: GlobalData.accountType == 1
                      ? CustomColors.green
                      : CustomColors.purple,
                  onChanged: (text) {
                    _payload['phone'] = text;
                  },
                ),
                Stack(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      alignment: GlobalData.accountType == 1
                          ? AlignmentDirectional(0, 0)
                          : AlignmentDirectional(10, 0),
                      child: RoundedInputField(
                        order: 5,
                        skipTraversal: GlobalData.accountType != 1,
                        enabled: GlobalData.accountType == 1,
                        required: GlobalData.accountType == 1,
                        labelText: 'Company Name',
                        hintText: 'Company Name',
                        width: _size.width * 0.8,
                        labelColor: GlobalData.accountType == 1
                            ? CustomColors.green
                            : CustomColors.purple,
                        onChanged: (text) {
                          if (GlobalData.accountType == 1)
                            _payload['companyName'] = text;
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      alignment: GlobalData.accountType == 0
                          ? AlignmentDirectional(0, 0)
                          : AlignmentDirectional(-10, 0),
                      child: RoundedInputField(
                        order: 5,
                        skipTraversal: GlobalData.accountType != 0,
                        enabled: GlobalData.accountType == 0,
                        required: GlobalData.accountType == 0,
                        labelText: 'Company Code',
                        hintText: '1234',
                        width: _size.width * 0.8,
                        labelColor: GlobalData.accountType == 1
                            ? CustomColors.green
                            : CustomColors.purple,
                        onChanged: (text) {
                          if (GlobalData.accountType == 0)
                            _payload['companyCode'] = text;
                        },
                      ),
                    ),
                  ],
                ),
                RoundedInputField(
                  order: 6,
                  labelText: 'Password',
                  hintText: 'Password',
                  obscureText: !_visible1,
                  width: _size.width * 0.8,
                  labelColor: GlobalData.accountType == 1
                      ? CustomColors.green
                      : CustomColors.purple,
                  onChanged: (text) {
                    _payload['password'] = text;
                  },
                  onFieldSubmitted: (text) {},
                  suffixIcon: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
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
                  order: 7,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
                  obscureText: !_visible2,
                  width: _size.width * 0.8,
                  labelColor: GlobalData.accountType == 1
                      ? CustomColors.green
                      : CustomColors.purple,
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    _payload['password_confirm'] = text;
                  },
                  suffixIcon: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
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
              ],
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
            text: 'SIGN UP',
            width: _size.width * 0.8,
            doAnimation: true,
            onPressed: () {
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
    print('register!');
    String dir = '/register';
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
    Size _size = MediaQuery.of(context).size;
    if (GlobalData.accountType == null) GlobalData.accountType = 0;
    return Container(
      width: _size.width * 0.7,
      height: 50,
      decoration: BoxDecoration(
        color: CustomColors.black,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            alignment: GlobalData.accountType == 1
                ? AlignmentDirectional(-0.9, 0)
                : AlignmentDirectional(0.9, 0),
            child: FractionallySizedBox(
              heightFactor: 1.0,
              widthFactor: 0.5,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: GlobalData.accountType == 1
                      ? CustomColors.green.withAlpha(150)
                      : CustomColors.purple.withAlpha(150),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            alignment: GlobalData.accountType == 1
                ? AlignmentDirectional(-1, 0)
                : AlignmentDirectional(1, 0),
            child: FractionallySizedBox(
              heightFactor: 1.0,
              widthFactor: 0.5,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: GlobalData.accountType == 1
                      ? CustomColors.green
                      : CustomColors.purple,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      GlobalData.accountType = 1;
                      context
                          .findAncestorStateOfType<State<SignUpScreen>>()!
                          .setState(() {});
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Employer',
                      style: TextStyle(
                        color: GlobalData.accountType == 1
                            ? CustomColors.black
                            : CustomColors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      GlobalData.accountType = 0;
                      context
                          .findAncestorStateOfType<State<SignUpScreen>>()!
                          .setState(() {});
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Worker',
                      style: TextStyle(
                        color: GlobalData.accountType == 0
                            ? CustomColors.black
                            : CustomColors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
