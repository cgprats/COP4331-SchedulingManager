import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/global_data.dart';
import 'package:mobile/components/rounded_button.dart';

class JobCard extends StatefulWidget {
  final String title, address, details;
  final double? width, height;
  final DateTime startDate, endDate;
  final Map<String, String> clientInfo;
  final int maxWorkers;
  final List<Map<String, String>> workers;

  const JobCard({
    required this.title,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.clientInfo,
    required this.maxWorkers,
    required this.workers,
    required this.details,
    this.width,
    this.height,
  });

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: widget.width,
        child: Column(
          children: <Widget>[
            _JobCardTitle(
              title: widget.title,
            ),
            _JobCardBody(
              address: widget.address,
              startDate: widget.startDate,
              endDate: widget.endDate,
              clientInfo: widget.clientInfo,
              maxWorkers: widget.maxWorkers,
              workers: widget.workers,
              details: widget.details,
            ),
          ],
        ),
      ),
    );
  }
}

class _JobCardTitle extends StatefulWidget {
  final String title;

  const _JobCardTitle({
    required this.title,
  });

  @override
  _JobCardTitleState createState() => _JobCardTitleState();
}

class _JobCardTitleState extends State<_JobCardTitle> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.orange,
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: CustomColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _JobCardBody extends StatefulWidget {
  final String address, details;
  final DateTime startDate, endDate;
  final Map<String, String> clientInfo;
  final int maxWorkers;
  final List<Map<String, String>> workers;

  const _JobCardBody({
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.clientInfo,
    required this.maxWorkers,
    required this.workers,
    required this.details,
  });

  @override
  _JobCardBodyState createState() => _JobCardBodyState();
}

class _JobCardBodyState extends State<_JobCardBody> {
  bool _expandClient = false;
  bool _expandTeam = false;
  bool _expandDetails = false;
  int _upArrow = 63534;
  int _downArrow = 63531;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: CustomColors.grey,
      ),
      child: Column(
        children: <Widget>[
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FractionColumnWidth(0.25),
            },
            children: <TableRow>[
              TableRow(
                children: <TableCell>[
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: CustomColors.white,
                              ),
                            ),
                          ),
                          child: Text(
                            'Location:',
                            style: TextStyle(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        widget.address,
                        style: TextStyle(
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <TableCell>[
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: CustomColors.white,
                              ),
                            ),
                          ),
                          child: Text(
                            'Duration:',
                            style: TextStyle(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Text(
                              _formatDate(widget.startDate),
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'to',
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              _formatDate(widget.endDate),
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <TableCell>[
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: CustomColors.white,
                              ),
                            ),
                          ),
                          child: Text(
                            'Client:',
                            style: TextStyle(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.only(top: 5, left: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible: !this._expandClient,
                            child: Expanded(
                              child: Container(
                                child: Text(
                                  '${widget.clientInfo['firstName']} ${widget.clientInfo['lastName']}',
                                  style: TextStyle(
                                    color: CustomColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: this._expandClient,
                            child: Expanded(
                              child: Table(
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FractionColumnWidth(0.25),
                                },
                                children: <TableRow>[
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          child: Text(
                                            'Name:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          child: Text(
                                            '${widget.clientInfo['firstName']} ${widget.clientInfo['lastName']}',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            'Email:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            '${widget.clientInfo['email']}',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <TableCell>[
                                      TableCell(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            'Phone:',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 2.5),
                                          child: Text(
                                            _formatPhone(
                                                widget.clientInfo['phone']!),
                                            style: TextStyle(
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                this._expandClient = !this._expandClient;
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                IconData(
                                  this._expandClient
                                      ? this._upArrow
                                      : this._downArrow,
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: CustomColors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      'Team: ${widget.workers.length} / ${widget.maxWorkers}',
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      this._expandTeam = !this._expandTeam;
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      IconData(
                        this._expandTeam ? this._upArrow : this._downArrow,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: CustomColors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: this._expandTeam,
            child: Table(
              columnWidths: <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: List<TableRow>.generate(
                widget.workers.length,
                (int index) {
                  Map<String, String> _worker = widget.workers[index];
                  return TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '${_worker['firstName']} ${_worker['lastName']}',
                            style: TextStyle(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '${_worker['email']}\n${_formatPhone(_worker['phone']!)}',
                            style: TextStyle(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      'Details:',
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      this._expandDetails = !this._expandDetails;
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      IconData(
                        this._expandDetails ? this._upArrow : this._downArrow,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: CustomColors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.details,
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                  overflow: this._expandDetails
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          _JobCardButtons(),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String _formatPhone([String phone = '']) {
    phone = phone.replaceAll(new RegExp('\\D'), '').padLeft(10, '0');
    return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }
}

class _JobCardButtons extends StatefulWidget {
  @override
  _JobCardButtonsState createState() => _JobCardButtonsState();
}

class _JobCardButtonsState extends State<_JobCardButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          RoundedButton(
            text: 'Notes',
            color: CustomColors.orange,
            onPressed: (){},
          ),
        ],
      ),
    );
  }
}