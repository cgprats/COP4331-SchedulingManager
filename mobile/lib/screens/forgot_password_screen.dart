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

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isBack = true;
  double angle = 0;

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
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: angle),
                  duration: Duration(seconds: 1),
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
                                "Enter your email",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              TextFieldWidget(
                                label: 'Email',
                                text: verify_payload['email'],
                                onChanged: (text) {
                                  verify_payload['email'] = text;
                                },
                              ),
                              RoundedButton(
                                text: 'Confirm',
                                width: _size.width * 0.25,
                                height: _size.height * 0.05,
                                fontSize: 15,
                                color: CustomColors.orange,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20),
                                onPressed: () {
                                  _verify(verify_payload);
                                  flip();
                                },
                              ),
                              Table(
                                columnWidths: const <int,
                                    TableColumnWidth>{
                                  0: FractionColumnWidth(0.40),
                                },
                                //defaultVerticalAlignment: TableCellVerticalAlignment,
                                children: <TableRow>[
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          child: Text(
                                            'First Name:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          child: Text(
                                            GlobalData.firstName!,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          child: Text(
                                            'Last Name:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          child: Text(
                                            GlobalData.lastName!,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          padding:
                                          EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            'Email:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          padding:
                                          EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            GlobalData.email!,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          padding:
                                          EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            'Phone:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          padding:
                                          EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            GlobalData.phone!,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          padding:
                                          EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            'Company Code:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          height: 30,
                                          padding:
                                          EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            GlobalData.companyCode
                                                .toString(),
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    RoundedButton(
                                      text: 'Sign Out',
                                      width: _size.width * 0.25,
                                      fontSize: 15,
                                      color: CustomColors.orange,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
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
                                    SizedBox(
                                      width: 20,
                                    ),
                                    RoundedButton(
                                      text: 'Edit',
                                      width: _size.width * 0.25,
                                      fontSize: 15,
                                      color: CustomColors.orange,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      onPressed: () {
                                        flip();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          )
                              : Transform(
                            transform: Matrix4.identity()
                              ..rotateY(pi),
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
                                  "New Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                TextFieldWidget(
                                  label: 'Verification Code',
                                  text: changepassword_payload['ver'],
                                  onChanged: (text) {
                                    changepassword_payload['ver'] = text;
                                  },
                                ),
                                const SizedBox(height: 24),
                                TextFieldWidget(
                                  label: 'Last Name',
                                  text: _payload['ln'],
                                  onChanged: (text) {
                                    _payload['ln'] = text;
                                  },
                                ),
                                const SizedBox(height: 24),
                                TextFieldWidget(
                                  label: 'Phone Number',
                                  text: _payload['phone'],
                                  onChanged: (text) {
                                    _payload['phone'] = text;
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      RoundedButton(
                                        text: 'Cancel',
                                        width: _size.width * 0.25,
                                        height: _size.height * 0.05,
                                        fontSize: 15,
                                        color: CustomColors.orange,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20),
                                        onPressed: () {
                                          flip();
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      RoundedButton(
                                        text: 'Confirm',
                                        width: _size.width * 0.25,
                                        height: _size.height * 0.05,
                                        fontSize: 15,
                                        color: CustomColors.orange,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20),
                                        onPressed: () {
                                          _payload['email'] =
                                              GlobalData.email;
                                          _edit(_payload);
                                          flip();
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
    );
  }
}