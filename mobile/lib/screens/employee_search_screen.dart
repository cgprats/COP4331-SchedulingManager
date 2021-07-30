import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/components/rounded_input_field.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/custom_scaffold.dart';
import 'package:mobile/components/employee_card.dart';
import 'package:mobile/components/employee_card_container.dart';
import 'package:mobile/components/textfield_widget.dart';

class EmployeeSearchScreen extends StatefulWidget {
  final GlobalKey<EmployeeSearchScreenState> key = GlobalKey();
  final GlobalKey<EmployeeCardContainerState> _employeeListKey = GlobalKey();

  EmployeeSearchScreen(key) : super(key: key);

  @override
  EmployeeSearchScreenState createState() => EmployeeSearchScreenState();
}

class EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  String _input = '';
  String _errorMessage = '';



  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return CustomScaffold(
      title: 'Employee Search',
      appBarColor: CustomColors.orange,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: CustomColors.purple,
        ),
        child: Center(
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedInputField(
                hintText: 'Search...',
                margin: EdgeInsets.zero,
                width: _size.width * 0.8,
                onChanged: (text) {
                  this._input = text;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  _search();
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: CustomColors.orange,
                  ),
                  onPressed: _search,
                ),
              ),
              EmployeeCardContainer(key: widget._employeeListKey),
            ],
          ),
        ),
      ),
    );
  }

  void _search() async {
    print('search!');
    Map _payload = Map();
    _payload['input'] = this._input;
    _payload['compCode'] = GlobalData.companyCode;
    String dir = '/searchWorkers';
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
          print('search successful!');
          _errorMessage = jsonObj['error'];
          if (_errorMessage.isEmpty) {
            widget._employeeListKey.currentState!.clearEmployeeCards();
            for (var employee in jsonObj['workers']) {
              if (employee == null) continue;
              print(employee);
              widget._employeeListKey.currentState!.addEmployeeCard(
                EmployeeCard(
                  width: 0.8,
                  clientInfo: {
                    'firstName': employee['firstName'],
                    'lastName': employee['lastName'],
                    'phone': employee['phone'],
                    'email': employee['Email'],
                  },
                ),
              );
            }
          }
        },
      );
    }
  }
  EmployeeCard sample1() {
    return EmployeeCard(
      width: 0.8,
      clientInfo: {
        'firstName': 'Bobby',
        'lastName': 'Dylan',
        'email': 'BobDill@gmail.com',
        'phone': '305-519-8560',
      },
    );
  }
}
