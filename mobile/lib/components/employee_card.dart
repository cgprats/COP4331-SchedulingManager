import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/global_data.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/notes_container.dart';
import 'package:mobile/components/timesheet_container.dart';

class EmployeeCard extends StatefulWidget {
  final Map<String, String> clientInfo;
  final double? width, height;

  const EmployeeCard({
    required this.clientInfo,
    this.width,
    this.height,
  });

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  Map notes_payload = {
    'name': '',
    'email': '',
  };
  Map timesheet_payload = {
    'name': '',
    'email': '',
  };
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widget.width,

      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: CustomColors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FractionColumnWidth(0.20),
                },
                children: <TableRow>[
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Name:',
                            style: TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(5),
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
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Email:',
                            style: TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(5),
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
                          height: 30,
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Phone:',
                            style: TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.all(5),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: RoundedButton(
                      text: 'Notes',
                      color: CustomColors.orange,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      onPressed: () {
                        notes_payload['email'] = widget.clientInfo['email'];
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NotesCard(
                              name: '${widget.clientInfo['firstName']}',
                              email: widget.clientInfo['email']!,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 2,
                    child: RoundedButton(
                      text: 'Timesheet',
                      color: CustomColors.orange,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      onPressed: () {
                        timesheet_payload['email'] = widget.clientInfo['email'];
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TimesheetCard(
                              name: '${widget.clientInfo['firstName']} ${widget.clientInfo['lastName']}',
                              email: widget.clientInfo['email']!,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatPhone([String phone = '']) {
    phone = phone.replaceAll(new RegExp('\\D'), '').padLeft(10, '0');
    return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }
}
