import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/components/rounded_input_field.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/custom_scaffold.dart';
import 'package:mobile/components/textfield_widget.dart';

class ManageAccountScreen2 extends StatefulWidget {
  @override
  _ManageAccountScreenState2 createState() => _ManageAccountScreenState2();
}

class _ManageAccountScreenState2 extends State<ManageAccountScreen2> {
  bool isBack = true;
  double angle = 0;
  Map _payload = {
    'fn': GlobalData.firstName,
    'ln': GlobalData.lastName,
    'phone': GlobalData.phone,
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
    return CustomScaffold(
      title: 'Manage Account',
      appBarColor: CustomColors.orange,
      backgroundColor: CustomColors.purple,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: _size.width * 0.8,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: CustomColors.orange,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Account Info',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CustomColors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: angle),
                    duration: Duration(milliseconds: 500),
                    builder: (BuildContext context, double val, _) {
                      if (val >= (pi / 2)) {
                        isBack = false;
                      } else {
                        isBack = true;
                      }
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(val),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: CustomColors.grey,
                          ),
                          child: Stack(
                            children: <Widget>[
                              Visibility(
                                maintainState: true,
                                maintainAnimation: true,
                                maintainSize: true,
                                visible: !isBack,
                                child: Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.identity()..rotateY(pi),
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: <Widget>[
                                          RoundedInputField(
                                            order: 1,
                                            labelText: 'First Name',
                                            initialValue: _payload['fn'],
                                            // width: _size.width * 0.8,
                                            keyboardType: TextInputType.name,
                                            labelColor: CustomColors.orange,
                                            onChanged: (text) {
                                              _payload['fn'] = text;
                                            },
                                          ),
                                          RoundedInputField(
                                            order: 2,
                                            labelText: 'Last Name',
                                            initialValue: _payload['ln'],
                                            // width: _size.width * 0.8,
                                            keyboardType: TextInputType.name,
                                            labelColor: CustomColors.orange,
                                            onChanged: (text) {
                                              _payload['ln'] = text;
                                            },
                                          ),
                                          RoundedInputField(
                                            order: 3,
                                            labelText: 'Phone',
                                            initialValue: _payload['phone'],
                                            // width: _size.width * 0.8,
                                            keyboardType: TextInputType.name,
                                            labelColor: CustomColors.orange,
                                            onChanged: (text) {
                                              _payload['phone'] = text;
                                            },
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: RoundedButton(
                                                  text: 'Cancel',
                                                  color: CustomColors.orange,
                                                  onPressed: () {
                                                    flip();
                                                  },
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 2,
                                                child: RoundedButton(
                                                  text: 'Confirm',
                                                  color: CustomColors.orange,
                                                  onPressed: () {
                                                    _payload['email'] =
                                                        GlobalData.email;
                                                    _edit(_payload);
                                                    flip();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                maintainState: true,
                                maintainAnimation: true,
                                maintainSize: true,
                                visible: isBack,
                                child: Column(
                                  children: <Widget>[
                                    TextField(
                                      readOnly: true,
                                      enabled: false,
                                      controller: TextEditingController(
                                        text: GlobalData.firstName,
                                      ),
                                      style: TextStyle(
                                        color: CustomColors.white,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10),
                                        labelText: 'First Name',
                                        labelStyle: TextStyle(
                                          color: CustomColors.orange,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      enabled: false,
                                      controller: TextEditingController(
                                        text: GlobalData.lastName,
                                      ),
                                      style: TextStyle(
                                        color: CustomColors.white,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10),
                                        labelText: 'Last Name',
                                        labelStyle: TextStyle(
                                          color: CustomColors.orange,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      enabled: false,
                                      controller: TextEditingController(
                                        text: GlobalData.email,
                                      ),
                                      style: TextStyle(
                                        color: CustomColors.white,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10),
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          color: CustomColors.orange,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      enabled: false,
                                      controller: TextEditingController(
                                        text: _formatPhone(GlobalData.phone!),
                                      ),
                                      style: TextStyle(
                                        color: CustomColors.white,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10),
                                        labelText: 'Phone',
                                        labelStyle: TextStyle(
                                          color: CustomColors.orange,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      enabled: false,
                                      controller: TextEditingController(
                                        text: GlobalData.companyCode,
                                      ),
                                      style: TextStyle(
                                        color: CustomColors.white,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                        EdgeInsets.only(bottom: 10),
                                        labelText: 'Company Code',
                                        labelStyle: TextStyle(
                                          color: CustomColors.orange,
                                        ),
                                        // border: InputBorder.none,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: RoundedButton(
                                            text: 'Sign Out',
                                            color: CustomColors.orange,
                                            onPressed: () {
                                              GlobalData.firstName = null;
                                              GlobalData.lastName = null;
                                              GlobalData.phone = null;
                                              GlobalData.email = null;
                                              GlobalData.accountType = 0;
                                              GlobalData.companyCode = null;
                                              GlobalData.companyName = null;
                                              GlobalData.verified = null;
                                              Navigator.popAndPushNamed(
                                                  context, Routes.LOGINSCREEN);
                                            },
                                          ),
                                        ),
                                        Spacer(),
                                        Expanded(
                                          flex: 2,
                                          child: RoundedButton(
                                            text: 'Edit',
                                            color: CustomColors.orange,
                                            onPressed: () {
                                              flip();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Column(
  // children: [
  // if (isBack) ...[
  // TextField(
  // readOnly: true,
  // enabled: false,
  // controller: TextEditingController(
  // text: GlobalData.firstName,
  // ),
  // style: TextStyle(
  // color: CustomColors.white,
  // ),
  // decoration: InputDecoration(
  // isDense: true,
  // contentPadding: EdgeInsets.only(bottom: 10),
  // labelText: 'First Name',
  // labelStyle: TextStyle(
  // color: CustomColors.orange,
  // ),
  // border: InputBorder.none,
  // ),
  // ),
  // TextField(
  // readOnly: true,
  // enabled: false,
  // controller: TextEditingController(
  // text: GlobalData.lastName,
  // ),
  // style: TextStyle(
  // color: CustomColors.white,
  // ),
  // decoration: InputDecoration(
  // isDense: true,
  // contentPadding: EdgeInsets.only(bottom: 10),
  // labelText: 'Last Name',
  // labelStyle: TextStyle(
  // color: CustomColors.orange,
  // ),
  // border: InputBorder.none,
  // ),
  // ),
  // TextField(
  // readOnly: true,
  // enabled: false,
  // controller: TextEditingController(
  // text: GlobalData.email,
  // ),
  // style: TextStyle(
  // color: CustomColors.white,
  // ),
  // decoration: InputDecoration(
  // isDense: true,
  // contentPadding: EdgeInsets.only(bottom: 10),
  // labelText: 'Email',
  // labelStyle: TextStyle(
  // color: CustomColors.orange,
  // ),
  // border: InputBorder.none,
  // ),
  // ),
  // TextField(
  // readOnly: true,
  // enabled: false,
  // controller: TextEditingController(
  // text: _formatPhone(GlobalData.phone!),
  // ),
  // style: TextStyle(
  // color: CustomColors.white,
  // ),
  // decoration: InputDecoration(
  // isDense: true,
  // contentPadding: EdgeInsets.only(bottom: 10),
  // labelText: 'Phone',
  // labelStyle: TextStyle(
  // color: CustomColors.orange,
  // ),
  // border: InputBorder.none,
  // ),
  // ),
  // TextField(
  // readOnly: true,
  // enabled: false,
  // controller: TextEditingController(
  // text: GlobalData.companyCode,
  // ),
  // style: TextStyle(
  // color: CustomColors.white,
  // ),
  // decoration: InputDecoration(
  // isDense: true,
  // contentPadding: EdgeInsets.only(bottom: 10),
  // labelText: 'Company Code',
  // labelStyle: TextStyle(
  // color: CustomColors.orange,
  // ),
  // // border: InputBorder.none,
  // border: InputBorder.none,
  // ),
  // ),
  // Row(
  // children: <Widget>[
  // Expanded(
  // flex: 2,
  // child: RoundedButton(
  // text: 'Sign Out',
  // color: CustomColors.orange,
  // onPressed: () {
  // GlobalData.firstName = null;
  // GlobalData.lastName = null;
  // GlobalData.phone = null;
  // GlobalData.email = null;
  // GlobalData.accountType = 0;
  // GlobalData.companyCode = null;
  // GlobalData.companyName = null;
  // GlobalData.verified = null;
  // Navigator.popAndPushNamed(
  // context, Routes.LOGINSCREEN);
  // },
  // ),
  // ),
  // Spacer(),
  // Expanded(
  // flex: 2,
  // child: RoundedButton(
  // text: 'Edit',
  // color: CustomColors.orange,
  // onPressed: () {
  // flip();
  // },
  // ),
  // ),
  // ],
  // ),
  // ] else ...[
  // Transform(
  // transform: Matrix4.identity()..rotateY(pi),
  // alignment: Alignment.center,
  // child: Column(
  // children: <Widget>[
  // RoundedInputField(
  // order: 1,
  // labelText: 'First Name',
  // initialValue: _payload['fn'],
  // // width: _size.width * 0.8,
  // keyboardType: TextInputType.name,
  // labelColor: CustomColors.orange,
  // onChanged: (text) {
  // _payload['fn'] = text;
  // },
  // ),
  // RoundedInputField(
  // order: 2,
  // labelText: 'Last Name',
  // initialValue: _payload['ln'],
  // // width: _size.width * 0.8,
  // keyboardType: TextInputType.name,
  // labelColor: CustomColors.orange,
  // onChanged: (text) {
  // _payload['ln'] = text;
  // },
  // ),
  // RoundedInputField(
  // order: 3,
  // labelText: 'Phone',
  // initialValue: _payload['phone'],
  // // width: _size.width * 0.8,
  // keyboardType: TextInputType.name,
  // labelColor: CustomColors.orange,
  // onChanged: (text) {
  // _payload['phone'] = text;
  // },
  // ),
  // Row(
  // children: <Widget>[
  // Expanded(
  // flex: 2,
  // child: RoundedButton(
  // text: 'Cancel',
  // color: CustomColors.orange,
  // onPressed: () {
  // flip();
  // },
  // ),
  // ),
  // Spacer(),
  // Expanded(
  // flex: 2,
  // child: RoundedButton(
  // text: 'Confirm',
  // color: CustomColors.orange,
  // onPressed: () {
  // _payload['email'] =
  // GlobalData.email;
  // _edit(_payload);
  // flip();
  // },
  // ),
  // ),
  // ],
  // ),
  // ],
  // ),
  // ),
  // ],
  // ],
  // ),

  String _formatPhone([String phone = '']) {
    phone = phone.replaceAll(new RegExp('\\D'), '').padLeft(10, '0');
    return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }

  void _edit(Map _payload) async {
    print('edit!');
    String dir = '/editaccount';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    print(_payload);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
        () {
          _errorMessage = jsonObj['error'];
          if (_errorMessage == 'Edits applied!') {
            _errorMessage = '';
            GlobalData.firstName = _payload['fn'];
            GlobalData.lastName = _payload['ln'];
            GlobalData.phone = _payload['phone'];
          }
        },
      );
    }
  }
}
