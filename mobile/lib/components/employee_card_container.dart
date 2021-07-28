import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/employee_card.dart';
import 'package:mobile/components/custom_scaffold.dart';

class EmployeeCardContainer extends StatefulWidget {
  const EmployeeCardContainer({Key? key}) : super(key: key);

  @override
  EmployeeCardContainerState createState() => EmployeeCardContainerState();
}

class EmployeeCardContainerState extends State<EmployeeCardContainer> {
  List<EmployeeCard> employees = [];

  void addEmployeeCard(EmployeeCard employeeCard) {
    employees.add(employeeCard);
  }

  void removeEmployeeCard(String id) {
    setState(() {
      for (EmployeeCard employee in employees) {
        if (employee.clientInfo['firstName'] == id) {
          employees.remove(employee);
          break;
        }
      }
    });
  }

  void clearEmployeeCards() {
    setState(() {
      employees.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: employees,
    );
  }
}
