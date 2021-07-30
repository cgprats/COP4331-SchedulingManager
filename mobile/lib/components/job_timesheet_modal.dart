import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card_container.dart';
import 'package:mobile/screens/job_listings_screen.dart';
import 'package:mobile/components/job_card.dart';
import 'package:mobile/components/custom_scaffold.dart';

class JobTimesheet extends StatelessWidget {
  final String jobId;

  JobTimesheet({
    required this.jobId,
  }); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _JobTimesheetTitle(),
      titlePadding: EdgeInsets.zero,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _JobTimesheetBody(
            jobId: this.jobId,
          );
        },
      ),
      contentPadding: EdgeInsets.zero,
      // actions: <Widget>[
      //   _JobTimesheetActions(jobId: this.jobId),
      // ],
      backgroundColor: CustomColors.grey,
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _JobTimesheetTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: CustomColors.orange,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Timesheet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobTimesheetBody extends StatefulWidget {
  final String jobId;

  _JobTimesheetBody({
    required this.jobId,
  });

  @override
  _JobTimesheetBodyState createState() => _JobTimesheetBodyState();
}

class _JobTimesheetBodyState extends State<_JobTimesheetBody> {
  GlobalKey<FormState> _formKey = GlobalKey();
  List<TableRow> _timesheet = [];

  @override
  void initState() {
    super.initState();
    _searchTimesheet(
      {
        'fooid': widget.jobId,
      },
    );
  }

  Map sample1 = {
    'firstName': 'Cameron',
    'lastName': 'Nichols',
    'start': '12:00 PM',
    'end': '3:00 PM',
    'date': '2021-07-03',
  };

  Map sample2 = {
    'firstName': 'John',
    'lastName': 'Doe',
    'start': '10:00 AM',
    'end': '11:37 AM',
    'date': '2021-08-29',
  };

  @override
  Widget build(BuildContext context) {
    // _addTime(sample1);
    // _addTime(sample2);
    return Container(
      padding: EdgeInsets.all(10),
      child: Table(
        columnWidths: <int, TableColumnWidth>{
          0: FlexColumnWidth(10),
          1: FlexColumnWidth(25),
          2: FlexColumnWidth(25),
        },
        children: <TableRow>[
          TableRow(
            children: <TableCell>[
              TableCell(
                child: Text(
                  'Date',
                  style: TextStyle(
                    color: CustomColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TableCell(
                child: Text(
                  'Hours',
                  style: TextStyle(
                    color: CustomColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TableCell(
                child: Text(
                  'Team Member',
                  style: TextStyle(
                    color: CustomColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ..._timesheet,
        ],
      ),
    );
  }

  void _addTime(Map _payload) {
    if (_payload['firstName'] == null ||
        _payload['lastName'] == null ||
        _payload['start'] == null ||
        _payload['end'] == null ||
        _payload['date'] == null) return;
    setState(
      () {
        _timesheet.add(
          TableRow(
            children: <TableCell>[
              TableCell(
                child: Text(
                  _formatDate(_payload['date']),
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TableCell(
                child: Text(
                  '${_payload['start']} - ${_payload['end']}',
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TableCell(
                child: Text(
                  '${_payload['firstName']} ${_payload['lastName']}',
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String date) {
    return '${date.substring(5, 7)}/${date.substring(8, 10)}/${date.substring(0, 4)}';
  }

  void _searchTimesheet(Map _payload) async {
    print('searchTimesheet!');
    String dir = '/searchTimesheet';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
        () {
          print('searchTimesheet successful!');
          for (var time in jsonObj['times']) {
            _addTime(time);
          }
        },
      );
    }
  }
}
