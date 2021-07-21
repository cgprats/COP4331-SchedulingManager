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
              JobCard(
                width: _size.width * 0.8,
                title: 'Title',
                address: '4000 Central Florida Blvd, Orlando, Fl, 32816',
                startDate: DateTime(2021, 7, 11),
                endDate: DateTime(2021, 7, 31),
                clientInfo: {
                  'firstName': 'John',
                  'lastName': 'Doe',
                  'email': 'example@email.com',
                  'phone': '(123) 456-7890',
                },
                maxWorkers: 4,
                workers: <Map<String, String>>[
                  {
                    'firstName': 'Bob',
                    'lastName': 'Anderson',
                    'email': 'email@gmail.com',
                    'phone': '(098) 765-4321',
                  },
                  {
                    'firstName': 'Sue',
                    'lastName': 'Smith',
                    'email': 'gang@hotmail.com',
                    'phone': '(890) 567-1234',
                  },
                ],
                details: () {
                  String text = '';
                  for (int i = 0; i < 10; i++) {
                    text += 'Very short briefing.';
                  }
                  return text;
                }(),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.lightGrey,
    );
  }
}
