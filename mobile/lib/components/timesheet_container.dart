import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/get_api.dart';

class TimesheetCard extends StatelessWidget {
  final String email;

  const TimesheetCard({
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _TimesheetTitle(),
      titlePadding: EdgeInsets.zero,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _TimesheetBody(
            email: this.email,
            // jobNotesKey: widget.key!,
          );
        },
      ),
      contentPadding: EdgeInsets.zero,
      // actions: <Widget>[
      //   _JobNotesActions(jobId: this.jobId),
      // ],
      backgroundColor: CustomColors.grey,
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _TimesheetTitle extends StatelessWidget {
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

class _TimesheetBody extends StatefulWidget {
  final String email;

  _TimesheetBody({
    required this.email,
  });

  @override
  _TimesheetBodyState createState() => _TimesheetBodyState();
}

class _TimesheetBodyState extends State<_TimesheetBody> {
  List<Widget> _timesheets = [];

  @override
  void initState() {
    super.initState();
    _searchTimesheets(
      {
        'email': widget.email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _timesheets,
    );
  }

  void _addTimesheet(Map _payload) {
    if (_payload['firstName'] == null ||
        _payload['lastName'] == null ||
        _payload['start'] == null ||
        _payload['end'] == null ||
        _payload['date'] == null) return;
    setState(
          () {
        _timesheets.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${_payload['date']}',
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_payload['start']} - ${_payload['end']}',
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _searchTimesheets(Map _payload) async {
    print('searchTimesheet!');
    String dir = '/searchIndividualTimesheet';
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
            _addTimesheet(time);
          }
        },
      );
    }
  }
}
