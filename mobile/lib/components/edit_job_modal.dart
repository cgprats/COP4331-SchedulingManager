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

class EditJobModal extends StatelessWidget {
  // final GlobalKey<JobListingsScreenState> jobScreenKey;

  final String jobId;
  final Map _payload = Map();

  EditJobModal({
    // required this.jobScreenKey,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    searchForJob();
    return AlertDialog(
      title: _EditJobTitle(),
      titlePadding: EdgeInsets.zero,
      content: _EditJobBody(
        payload: _payload,
      ),
      contentPadding: EdgeInsets.zero,
      actions: <Widget>[
        _EditJobActions(
          payload: _payload,
        ),
      ],
      backgroundColor: CustomColors.grey,
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  void searchForJob() async {
    print('searchForJob!');
    String dir = '/searchJobs';
    String ret = await API.getJson(dir, {
      'input': '',
      'companyCode': GlobalData.companyCode,
      'email': GlobalData.email,
    });
    print(ret);
    print(_payload);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      print('searchJobs successful!');
      if (jsonObj['error'].isEmpty) {
        for (var job in jsonObj['jobs']) {
          if (job == null) continue;
          print(job);
          if (job['_id'] == this.jobId) {
            _payload['id'] = job['_id'];
            _payload['title'] = job['title'];
            _payload['email'] = job['email'];
            _payload['address'] = job['address'];
            _payload['clientname'] = job['clientname'];
            _payload['clientcontact'] = job['clientcontact'];
            _payload['start'] = job['start'];
            _payload['end'] = job['end'];
            _payload['max'] = job['maxworkers'];
            _payload['briefing'] = job['briefing'];
            return;
          }
        }
      }
      // setState(
      //       () {
      //     print('searchJobs successful!');
      //     _errorMessage = jsonObj['error'];
      //     if (_errorMessage.isEmpty) {
      //       widget._jobListKey.currentState!.clearJobCards();
      //       for (var job in jsonObj['jobs']) {
      //         if (job == null) continue;
      //         print(job);
      //         widget._jobListKey.currentState!.addJobCard(
      //           JobCard(
      //             width: 0.8,
      //             jobListKey: widget._jobListKey,
      //             id: job['_id'],
      //             isComplete: job['completed'],
      //             title: '${job['title']}',
      //             clientInfo: {
      //               'firstName': job['clientname'],
      //               'lastName': '',
      //               'phone': job['clientcontact'],
      //               'email': job['email'],
      //             },
      //             startDate: (job['start'] != null && job['start'] != '')
      //                 ? DateTime.parse(job['start'])
      //                 : null,
      //             endDate: (job['end'] != null && job['end'] != '')
      //                 ? DateTime.parse(job['end'])
      //                 : null,
      //             address: '${job['address']}',
      //             workers: [],
      //             maxWorkers: job['maxworkers'] != null ? job['maxworkers'] : '0',
      //             details: '${job['briefing']}',
      //           ),
      //         );
      //       }
      //     }
      //   },
      // );
    }
  }
}

class _EditJobTitle extends StatelessWidget {
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
              'Edit Job',
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

class _EditJobBody extends StatefulWidget {
  final Map payload;

  const _EditJobBody({
    required this.payload,
  });

  @override
  _EditJobBodyState createState() => _EditJobBodyState();
}

class _EditJobBodyState extends State<_EditJobBody> {
  DateTime? _startDate, _endDate;
  GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _selectDate(BuildContext context,
      {bool isStartDate = false}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100, 12, 12),
    );
    if (pickedDate != null)
      setState(() {
        if (isStartDate) {
          this._startDate = pickedDate;
          widget.payload['start'] = _formatDate2(this._startDate);
        } else {
          this._endDate = pickedDate;
          widget.payload['end'] = _formatDate2(this._endDate);
        }
      });
  }

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.parse(widget.payload['start']);
    _endDate = DateTime.parse(widget.payload['end']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            RoundedInputField(
              labelText: 'Title',
              labelColor: CustomColors.orange,
              initialValue: widget.payload['title'],
              onChanged: (value) {
                widget.payload['title'] = value;
              },
            ),
            RoundedInputField(
              labelText: 'Address',
              labelColor: CustomColors.orange,
              onChanged: (value) {
                widget.payload['address'] = value;
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Start Date:',
                    style: TextStyle(
                      color: CustomColors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    label: Text(
                      this._startDate == null
                          ? 'beginning'
                          : _formatDate1(this._startDate!),
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                    ),
                    icon: Icon(
                      Icons.calendar_today,
                      color: CustomColors.orange,
                    ),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        CustomColors.orange.withAlpha(75),
                      ),
                    ),
                    onPressed: () {
                      this._selectDate(
                        context,
                        isStartDate: true,
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'End Date:',
                    style: TextStyle(
                      color: CustomColors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    label: Text(
                      this._endDate == null
                          ? 'end'
                          : _formatDate1(this._endDate!),
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                    ),
                    icon: Icon(
                      Icons.calendar_today,
                      color: CustomColors.orange,
                    ),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        CustomColors.orange.withAlpha(75),
                      ),
                    ),
                    onPressed: () {
                      this._selectDate(
                        context,
                        isStartDate: false,
                      );
                    },
                  ),
                ),
              ],
            ),
            RoundedInputField(
              labelText: 'Max Workers',
              labelColor: CustomColors.orange,
              onChanged: (value) {
                widget.payload['max'] = value;
              },
            ),
            RoundedInputField(
              labelText: 'Details',
              labelColor: CustomColors.orange,
              onChanged: (value) {
                widget.payload['briefing'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate1(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String _formatDate2(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

class _EditJobActions extends StatelessWidget {
  final Map payload;

  _EditJobActions({
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RoundedButton(
        text: 'Apply',
        width: double.infinity,
        color: CustomColors.orange,
        fontSize: 24,
        onPressed: () {
          print('pressed!');
          payload['email'] = GlobalData.email;
          payload['clientname'] =
              '${GlobalData.firstName} ${GlobalData.lastName}';
          payload['clientcontact'] = _formatPhone(GlobalData.phone!);
          payload['companyCode'] = GlobalData.companyCode;
        },
      ),
    );
  }

  String _formatPhone([String phone = '']) {
    phone = phone.replaceAll(new RegExp('\\D'), '').padLeft(10, '0');
    return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }
}
