import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card.dart';
import 'package:mobile/components/custom_scaffold.dart';
import 'package:mobile/components/job_card_container.dart';
import 'package:mobile/components/job_search_bar.dart';
import 'package:mobile/components/add_job_modal.dart';

class JobListingsScreen extends StatefulWidget {
  @override
  _JobListingsScreenState createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  Map _payload = Map();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    GlobalKey<JobCardContainerState> _jobListKey = GlobalKey();
    return CustomScaffold(
      title: 'Job Listings',
      appBarColor: CustomColors.orange,
      backgroundColor: Color(0xFFDFDFDF),
      body: ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              JobSearchBar(),
              Visibility(
                visible: GlobalData.accountType == 1,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: CustomColors.orange,
                  ),
                  onPressed: () {
                    // _jobListKey.currentState!.addJobCard(sample1());
                    _payload['title'] = 'api title';
                    _payload['email'] = GlobalData.email;
                    _payload['address'] = 'an address';
                    _payload['clientname'] = '${GlobalData.firstName} ${GlobalData.lastName}';
                    _payload['clientcontact'] = GlobalData.phone;
                    _payload['start'] = '2021-07-03';
                    _payload['end'] = '2021-07-29';
                    _payload['companyCode'] = GlobalData.companyCode;
                    _payload['max'] = 4;
                    _payload['briefing'] = 'briefing!';
                    _addOrder(_payload);
                    _searchTitle();
                    _jobListKey.currentState!.setState(() {});
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AddJobModal(jobListKey: _jobListKey);
                    //   },
                    // );
                  },
                ),
              ),
            ],
          ),
          JobCardContainer(key: _jobListKey),
        ],
      ),
    );
  }

  void _addOrder(Map _payload) async {
    print('addorder!');
    String dir = '/addorder';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
            () {
          print('addorder successful!');
          _errorMessage =
          jsonObj['error'] == 'Job added!' ? '' : jsonObj['error'];
        },
      );
    }
  }

  void _searchTitle() async {
    print('searchTitle!');
    String dir = '/searchTitle';
    String ret = await API.getJson(dir, {'title': 'api title'});
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
            () {
          print('searchTitle successful!');
          // _errorMessage =
          // jsonObj['error'] == 'Job added!' ? '' : jsonObj['error'];
        },
      );
    }
  }

  JobCard sample1() {
    return JobCard(
      width: 0.8,
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
    );
  }

  JobCard sample2() {
    return JobCard(
      width: 0.8,
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
      details:
          'This is a longer briefing. It has formatting in the form of this list. '
          'Definitely going to need word wrap to make this look nice, because ho boy '
          'just look how long its getting',
    );
  }
}
