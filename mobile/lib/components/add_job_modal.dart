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

class AddJobModal extends StatelessWidget {
  final GlobalKey<JobListingsScreenState> jobScreenKey;

  final Map _payload = Map();

  AddJobModal({
    required this.jobScreenKey,
  });

  @override
  Widget build(BuildContext context) {
    _payload['title'] = '';
    _payload['address'] = '';
    _payload['max'] = '';
    _payload['briefing'] = '';
    return AlertDialog(
      title: _AddJobTitle(),
      titlePadding: EdgeInsets.zero,
      content: _AddJobBody(
        jobScreenKey: jobScreenKey,
        payload: _payload,
      ),
      contentPadding: EdgeInsets.zero,
      actions: <Widget>[
        _AddJobActions(payload: _payload, jobScreenKey: jobScreenKey),
      ],
      backgroundColor: CustomColors.grey,
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Add New Job',
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

class _AddJobBody extends StatefulWidget {
  final GlobalKey<JobListingsScreenState> jobScreenKey;
  final Map payload;

  const _AddJobBody({
    required this.jobScreenKey,
    required this.payload,
  });

  @override
  _AddJobBodyState createState() => _AddJobBodyState();
}

class _AddJobBodyState extends State<_AddJobBody> {
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

class _AddJobActions extends StatelessWidget {
  final GlobalKey<JobListingsScreenState> jobScreenKey;
  final Map payload;

  _AddJobActions({
    required this.payload,
    required this.jobScreenKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RoundedButton(
        text: 'Add Job',
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
          this.jobScreenKey.currentState!.addOrder(payload);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _formatPhone([String phone = '']) {
    phone = phone.replaceAll(new RegExp('\\D'), '').padLeft(10, '0');
    return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }
}
