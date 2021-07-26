import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card_container.dart';
import 'package:mobile/components/job_card.dart';
import 'package:mobile/components/custom_scaffold.dart';

class AddJobModal extends StatelessWidget {
  final GlobalKey<JobCardContainerState> jobListKey;

  const AddJobModal({
    required this.jobListKey,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: <Widget>[
            _AddJobTitle(),
            _AddJobBody(jobListKey: jobListKey),
          ],
        ),
      ),
    );
  }
}

class _AddJobTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: CustomColors.orange,
      ),
      child: Text(
        'Add New Job',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: CustomColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AddJobBody extends StatefulWidget {
  final GlobalKey<JobCardContainerState> jobListKey;

  const _AddJobBody({
    required this.jobListKey,
  });

  @override
  _AddJobBodyState createState() => _AddJobBodyState();
}

class _AddJobBodyState extends State<_AddJobBody> {
  DateTime? _startDate, _endDate;
  String? _title, _address, _details;
  int? _maxWorkers;
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
        if (isStartDate)
          this._startDate = pickedDate;
        else
          this._endDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomColors.grey,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            RoundedInputField(
              labelText: 'Title',
              labelColor: CustomColors.orange,
              onChanged: (value) {
                this._title = value;
              },
            ),
            RoundedInputField(
              labelText: 'Address',
              labelColor: CustomColors.orange,
              onChanged: (value) {
                this._address = value;
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
                          : _formatDate(this._startDate!),
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
                          : _formatDate(this._endDate!),
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
                this._maxWorkers = int.parse(value);
              },
            ),
            RoundedInputField(
              labelText: 'Details',
              labelColor: CustomColors.orange,
              onChanged: (value) {
                this._details = value;
              },
            ),
            RoundedButton(
              text: 'Add Job',
              color: CustomColors.orange,
              onPressed: () {
                widget.jobListKey.currentState!.addJobCard(
                  JobCard(
                    title: this._title!,
                    address: this._address!,
                    startDate: this._startDate!,
                    endDate: this._endDate!,
                    clientInfo: {
                      'firstName': 'Bobby',
                      'lastName': 'Dylan',
                      'email': 'BobDill@gmail.com',
                      'phone': '305-519-8560',
                    },
                    maxWorkers: this._maxWorkers!,
                    workers: <Map<String, String>>[],
                    details: this._details!,
                  ),
                );
                widget.jobListKey.currentState!.setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }
}
