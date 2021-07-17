import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/global_data.dart';

class JobCard extends StatefulWidget {
  final String title, address;
  final double? width, height;

  const JobCard({
    this.title = 'Title',
    this.address = 'Address',
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
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          children: <Widget>[
            _JobCardTitle(),
          ],
        ),
      ),
    );
  }
}

class _JobCardTitle extends StatefulWidget {
  final String title;

  const _JobCardTitle({
    this.title = 'Title',
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
          color: CustomColors.white,
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
