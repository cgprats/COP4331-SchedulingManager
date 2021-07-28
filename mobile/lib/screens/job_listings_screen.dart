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
import 'package:mobile/components/job_notes_modal.dart';

class JobListingsScreen extends StatefulWidget {
  final GlobalKey<JobListingsScreenState> key = GlobalKey();
  final GlobalKey<JobCardContainerState> _jobListKey = GlobalKey();

  JobListingsScreen(key) : super(key: key);

  @override
  JobListingsScreenState createState() => JobListingsScreenState();
}

class JobListingsScreenState extends State<JobListingsScreen> {
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return CustomScaffold(
      title: 'Job Listings',
      appBarColor: CustomColors.orange,
      backgroundColor: Color(0xFFDFDFDF),
      body: ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              JobSearchBar(jobScreenKey: widget.key),
              Visibility(
                visible: GlobalData.accountType == 1,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: CustomColors.orange,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddJobModal(jobScreenKey: widget.key);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          JobCardContainer(key: widget._jobListKey),
        ],
      ),
    );
  }

  void addOrder(Map _payload) async {
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

  void searchJobs(Map _payload) async {
    print('searchJobs!');
    String dir = '/searchJobs';
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
          print('searchJobs successful!');
          _errorMessage = jsonObj['error'];
          if (_errorMessage.isEmpty) {
            widget._jobListKey.currentState!.clearJobCards();
            for (var job in jsonObj['jobs']) {
              if (job == null) continue;
              print(job);
              widget._jobListKey.currentState!.addJobCard(
                JobCard(
                  width: 0.8,
                  jobListKey: widget._jobListKey,
                  id: job['_id'],
                  isComplete: job['completed'],
                  title: '${job['title']}',
                  clientInfo: {
                    'firstName': job['clientname'],
                    'lastName': '',
                    'phone': job['clientcontact'],
                    'email': job['email'],
                  },
                  startDate: (job['start'] != null && job['start'] != '')
                      ? DateTime.parse(job['start'])
                      : null,
                  endDate: (job['end'] != null && job['end'] != '')
                      ? DateTime.parse(job['end'])
                      : null,
                  address: '${job['address']}',
                  workers: [],
                  maxWorkers: job['maxworkers'] != null ? job['maxworkers'] : '0',
                  details: '${job['briefing']}',
                ),
              );
            }
          }
        },
      );
    }
  }

  // JobCard sample1() {
  //   return JobCard(
  //     width: 0.8,
  //     title: 'This is an example title',
  //     address: '4000 Central Florida Blvd, Orlando, Fl, 32816',
  //     startDate: DateTime(2021, 7, 18),
  //     endDate: DateTime(2021, 7, 21),
  //     clientInfo: {
  //       'firstName': 'Bobby',
  //       'lastName': 'Dylan',
  //       'email': 'BobDill@gmail.com',
  //       'phone': '305-519-8560',
  //     },
  //     maxWorkers: 4,
  //     workers: <Map<String, String>>[],
  //     details: 'This is a very short example briefing with no formatting',
  //   );
  // }
  //
  // JobCard sample2() {
  //   return JobCard(
  //     width: 0.8,
  //     title: 'This is a second example title',
  //     address: '9000 SW 196 Dr',
  //     startDate: DateTime(2021, 7, 25),
  //     endDate: DateTime(2021, 8, 2),
  //     clientInfo: {
  //       'firstName': 'Biggie',
  //       'lastName': 'Smalls',
  //       'email': 'biggieDaGoat@hotmail.com',
  //       'phone': '305-804-0523',
  //     },
  //     maxWorkers: 6,
  //     workers: <Map<String, String>>[
  //       {
  //         'firstName': 'Sean',
  //         'lastName': 'Bennett',
  //         'email': 'seanmbmiami@gmail.com',
  //         'phone': '305-519-8560',
  //       },
  //       {
  //         'firstName': 'Trish',
  //         'lastName': 'Nigrelli',
  //         'email': 'kmbmiami@gmail.com',
  //         'phone': '786-367-6792',
  //       },
  //     ],
  //     details:
  //         'This is a longer briefing. It has formatting in the form of this list. '
  //         'Definitely going to need word wrap to make this look nice, because ho boy '
  //         'just look how long its getting',
  //   );
  // }
}
