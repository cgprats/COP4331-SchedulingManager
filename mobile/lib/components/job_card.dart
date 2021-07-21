import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/global_data.dart';

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
            fontSize: 30,
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
                      child: Text(
                        'Location:',
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
                      child: Text(
                        'Duration:',
                        style: TextStyle(
                          color: CustomColors.white,
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
                      child: Text(
                        'Client:',
                        style: TextStyle(
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.3),
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
                                    _formatPhone(widget.clientInfo['phone']!),
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
                ],
              ),
            ],
          ),
          Text(
            '\nTeam: ${widget.workers.length} / ${widget.maxWorkers}',
            style: TextStyle(
              color: CustomColors.white,
            ),
          ),
          Table(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '\nDetails:',
                style: TextStyle(
                  color: CustomColors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this._expandDetails = !this._expandDetails;
                  });
                },
                child: Icon(
                  IconData(
                    this._expandDetails ? this._upArrow : this._downArrow,
                    fontFamily: 'MaterialIcons',
                  ),
                  size: 16,
                  color: CustomColors.orange,
                ),
              ),
              // IconButton(
              //   color: CustomColors.orange,
              //   // iconSize: 10,
              //   icon: Icon(
              //     IconData(
              //       this._expandDetails ? this._upArrow : this._downArrow,
              //       fontFamily: 'MaterialIcons',
              //     ),
              //   ),
              //   onPressed: () {
              //     setState(() {
              //       this._expandDetails = !this._expandDetails;
              //     });
              //   },
              // ),
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
