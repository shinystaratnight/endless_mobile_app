import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';

class CandidateTimesheetDetailsScreen extends StatefulWidget {
  final String position;

  CandidateTimesheetDetailsScreen({this.position});

  @override
  _CandidateTimesheetDetailsScreenState createState() =>
      _CandidateTimesheetDetailsScreenState();
}

class _CandidateTimesheetDetailsScreenState
    extends State<CandidateTimesheetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getCandidateAppBar('Timesheet', context),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  widget.position,
                  style: TextStyle(fontSize: 22.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.0,
                ),
                GroupTitle(title: 'Times'),
                DetailsRecord(
                  label: 'Shift Date',
                  value: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                ),
                DetailsRecord(
                  label: 'Shift Start Time',
                  value: DateFormat.jm().format(DateTime.now()),
                ),
                DetailsRecord(
                  label: 'Break Start Time',
                  value: DateFormat.jm().format(DateTime.now()),
                ),
                DetailsRecord(
                  label: 'Break End Time',
                  value: DateFormat.jm().format(DateTime.now()),
                ),
                DetailsRecord(
                  label: 'Shift End Time',
                  value: DateFormat.jm().format(DateTime.now()),
                ),
                GroupTitle(title: 'Job Information'),
                DetailsRecord(
                  label: 'Jobsite',
                  value: 'Smart Builders LTD - Tartu',
                ),
                DetailsRecord(
                  label: 'Site Manager',
                  value: 'Project Manager Mr. Duncan Pallar',
                ),
                DetailsRecord(
                  label: 'Address',
                  value: 'Some address',
                ),
              ],
            ),
          ),
        ));
  }
}
