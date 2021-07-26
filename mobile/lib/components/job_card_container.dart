import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card.dart';
import 'package:mobile/components/custom_scaffold.dart';

class JobCardContainer extends StatefulWidget {
  const JobCardContainer({Key? key}) : super(key: key);

  @override
  JobCardContainerState createState() => JobCardContainerState();
}

class JobCardContainerState extends State<JobCardContainer> {
  List<JobCard> jobs = [];

  void addJobCard(JobCard jobCard) {
    setState(() {
      jobs.add(jobCard);
    });
  }

  void clearJobCards() {
    setState(() {
      jobs = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: jobs,
    );
  }
}
