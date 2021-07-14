import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/CustomColors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded-password-field.dart';
import 'package:mobile/components/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? firstName,
      lastName,
      phone,
      email,
      password,
      passwordConfirm,
      employerCode;

  @override
  Widget build(BuildContext context) {
    // MediaQueryData mq = MediaQuery.of(context);
    // Size size = Size(
    //   mq.size.width,
    //   mq.size.height - mq.viewInsets.vertical - mq.viewPadding.vertical - mq.padding.vertical,
    // );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RoundedInputField(
                labelText: 'First Name',
                hintText: 'John',
                width: size.width * 0.8,
                onChanged: (text) {
                  firstName = text;
                },
                autofocus: true,
              ),
              RoundedInputField(
                labelText: 'Last Name',
                hintText: 'Doe',
                width: size.width * 0.8,
                onChanged: (text) {
                  lastName = text;
                },
              ),
              RoundedInputField(
                labelText: 'Email',
                hintText: 'john.doe@email.com',
                width: size.width * 0.8,
                onChanged: (text) {
                  email = text;
                },
              ),
              RoundedInputField(
                labelText: 'Phone Number',
                hintText: '(123) 456-7890',
                width: size.width * 0.8,
                onChanged: (text) {
                  phone = text;
                },
              ),
              RoundedPasswordField(
                width: size.width * 0.8,
                onChanged: (text) {
                  password = text;
                },
              ),
              RoundedPasswordField(
                labelText: 'Confirm Password',
                hintText: 'Confirm Password',
                width: size.width * 0.8,
                onChanged: (text) {
                  passwordConfirm = text;
                },
              ),
              RoundedButton(
                text: 'Submit',
                onPress: registerWorker,
                width: size.width * 0.8,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.grey,
    );
  }

  void registerWorker() async {
    String dir = '/registerworker';
    Map payload = {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'password': password,
      'password_confirm': passwordConfirm,
      'employercode': employerCode,
    };
    String ret = await API.getJson(dir, payload);
    var jsonObj = json.decode(ret);
    if (ret.isEmpty) {
      print('something is fucked up!');
    } else {
      GlobalData.firstName = jsonObj['firstName'];
      GlobalData.lastName = jsonObj['lastName'];
      GlobalData.phone = jsonObj['phone'];
      GlobalData.email = jsonObj['email'];
      GlobalData.password = jsonObj['password'];
      GlobalData.companyInfo = jsonObj['employercode'];
    }
  }
}
