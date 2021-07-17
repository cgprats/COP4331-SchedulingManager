import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card.dart';

class JobListingsScreen extends StatefulWidget {
  @override
  _JobListingsScreenState createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
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
                "Job Listings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white,
                  fontSize: 30,
                ),
              ),
              RoundedInputField(
                hintText: 'Search...',
                width: _size.width * 0.8,
              ),
              JobCard(
                width: _size.width * 0.8,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.grey,
    );
  }
}