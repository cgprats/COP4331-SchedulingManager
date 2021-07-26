import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/components/rounded_input_field.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/custom_scaffold.dart';
import 'package:mobile/components/textfield_widget.dart';

class EmployeeSearchScreen extends StatefulWidget{
  @override
  _EmployeeSearchScreenState createState() => _EmployeeSearchScreenState();
}

class _EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  String? _input;
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return CustomScaffold(
      title: 'Employee Search',
      appBarColor: CustomColors.orange,
      body: Container(
        child: Column(
          children: <Widget>[
            RoundedInputField(
              hintText: 'Search...',
              margin: EdgeInsets.zero,
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
            )
          ],
        )
      )
    );
  }

  void _search() {
    print('search!');
    Map _payload = Map();
    _payload['input'] = this._input;
    _payload['compCode'] = GlobalData.companyCode;
  }
}