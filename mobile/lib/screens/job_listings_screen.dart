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
                title: 'This is an example title',
                address: '4000 Central Florida Blvd, Orlando, Fl, 32816',
                startDate: DateTime(2021, 7, 18),
                endDate: DateTime(2021, 7, 21),
                clientInfo: {
                  'firstName': 'Bobby',
                  'lastName': 'Dylan',
                  'email': 'BobDill@gmail.com',
                  'phone': '305-519-8560',
                },
                maxWorkers: 4,
                workers: <Map<String, String>>[],
                details: 'This is a very short example briefing with no formatting',
              ),
              JobCard(
                width: _size.width * 0.8,
                title: 'This is a second example title',
                address: '9000 SW 196 Dr',
                startDate: DateTime(2021, 7, 25),
                endDate: DateTime(2021, 8, 2),
                clientInfo: {
                  'firstName': 'Biggie',
                  'lastName': 'Smalls',
                  'email': 'biggieDaGoat@hotmail.com',
                  'phone': '305-804-0523',
                },
                maxWorkers: 6,
                workers: <Map<String, String>>[
                  {
                    'firstName': 'Sean',
                    'lastName': 'Bennett',
                    'email': 'seanmbmiami@gmail.com',
                    'phone': '305-519-8560',
                  },
                  {
                    'firstName': 'Trish',
                    'lastName': 'Nigrelli',
                    'email': 'kmbmiami@gmail.com',
                    'phone': '786-367-6792',
                  },
                ],
                details: 'This is a longer briefing. It has formatting in the form of this list. '
                    'Definitely going to need word wrap to make this look nice, because ho boy '
                    'just look how long its getting',
              ),
              JobCard(
                width: _size.width * 0.8,
                title: 'This is a second example title',
                address: '9000 SW 196 Dr',
                startDate: DateTime(2021, 7, 25),
                endDate: DateTime(2021, 8, 2),
                clientInfo: {
                  'firstName': 'Biggie',
                  'lastName': 'Smalls',
                  'email': 'biggieDaGoat@hotmail.com',
                  'phone': '305-804-0523',
                },
                maxWorkers: 6,
                workers: <Map<String, String>>[
                  {
                    'firstName': 'Sean',
                    'lastName': 'Bennett',
                    'email': 'seanmbmiami@gmail.com',
                    'phone': '305-519-8560',
                  },
                  {
                    'firstName': 'Trish',
                    'lastName': 'Nigrelli',
                    'email': 'kmbmiami@gmail.com',
                    'phone': '786-367-6792',
                  },
                ],
                details: 'This is a longer briefing. It has formatting in the form of this list. '
                    'Definitely going to need word wrap to make this look nice, because ho boy '
                    'just look how long its getting',
              ),
              JobCard(
                width: _size.width * 0.8,
                title: 'This is a second example title',
                address: '9000 SW 196 Dr',
                startDate: DateTime(2021, 7, 25),
                endDate: DateTime(2021, 8, 2),
                clientInfo: {
                  'firstName': 'Biggie',
                  'lastName': 'Smalls',
                  'email': 'biggieDaGoat@hotmail.com',
                  'phone': '305-804-0523',
                },
                maxWorkers: 6,
                workers: <Map<String, String>>[
                  {
                    'firstName': 'Sean',
                    'lastName': 'Bennett',
                    'email': 'seanmbmiami@gmail.com',
                    'phone': '305-519-8560',
                  },
                  {
                    'firstName': 'Trish',
                    'lastName': 'Nigrelli',
                    'email': 'kmbmiami@gmail.com',
                    'phone': '786-367-6792',
                  },
                ],
                details: 'This is a longer briefing. It has formatting in the form of this list. '
                    'Definitely going to need word wrap to make this look nice, because ho boy '
                    'just look how long its getting',
              ),
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.lightGrey,
    );
  }
}
