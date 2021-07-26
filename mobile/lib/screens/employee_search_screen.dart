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
import 'package:mobile/components/textfield_widget.dart';

class EmployeeSearchScreen extends StatefulWidget {
  @override
  _EmployeeSearchScreenState createState() => _EmployeeSearchScreenState();
}

class _EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  String? _input;
  String _errorMessage = '';
  List<EmployeeCard> employees = [];


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
                onChanged: (value) {
                  this._input = value;
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
              //employees,
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
    var jsonObj = json.decode(ret);
    //print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
        () {
          print('searchJobs successful!');
          _errorMessage =
              jsonObj['error'] == 'Job added!' ? '' : jsonObj['error'];
        },
      );
    }
  }
  void addEmployee() {
    employees.add(sample1());
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
