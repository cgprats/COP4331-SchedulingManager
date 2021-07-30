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

class ConfirmDelete extends StatelessWidget {
  final String id;

  ConfirmDelete({
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _Title(),
      titlePadding: EdgeInsets.zero,
      content: _Body(),
      contentPadding: EdgeInsets.zero,
      actions: <Widget>[
        _Actions(id: this.id),
      ],
      backgroundColor: CustomColors.grey,
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _Title extends StatelessWidget {
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
              'Delete Job',
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

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Are You Sure You Want to Delete This Job?',
        style: TextStyle(
          color: CustomColors.white,
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final String id;

  _Actions({
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RoundedButton(
            text: 'Cancel',
            // width: double.infinity,
            color: CustomColors.orange,
            fontSize: 24,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(child: RoundedButton(
          text: 'Delete',
          // width: double.infinity,
          color: CustomColors.orange,
          fontSize: 24,
          onPressed: () {
            _deleteOrder({'id': this.id});
            Navigator.pop(context);
          },
        ),),
      ],
    );
  }

  void _deleteOrder(Map _payload) async {
    print('deleteorder!');
    String dir = '/deleteorder';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      print('deleteorder successful!');
    }
  }
}
