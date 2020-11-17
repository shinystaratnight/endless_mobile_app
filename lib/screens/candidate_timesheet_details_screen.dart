import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';

class CandidateTimesheetDetailsScreen extends StatefulWidget {
  final String position;
  final String jobsite;
  final String clientContact;
  final String address;
  final DateTime shiftDate;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final DateTime breakStart;
  final DateTime breakEnd;

  CandidateTimesheetDetailsScreen({
    this.position = '',
    this.jobsite,
    this.clientContact,
    this.address,
    this.shiftDate,
    this.shiftStart,
    this.shiftEnd,
    this.breakStart,
    this.breakEnd,
  });

  @override
  _CandidateTimesheetDetailsScreenState createState() =>
      _CandidateTimesheetDetailsScreenState();
}

class _CandidateTimesheetDetailsScreenState
    extends State<CandidateTimesheetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCandidateAppBar('Timesheet', context, showNotification: false),
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
                value: DateFormat('dd/MM/yyyy').format(widget.shiftDate),
              ),
              DetailsRecord(
                label: 'Shift Start Time',
                value: DateFormat.jm().format(widget.shiftStart),
              ),
              DetailsRecord(
                label: 'Break Start Time',
                value: DateFormat.jm().format(widget.breakStart),
              ),
              DetailsRecord(
                label: 'Break End Time',
                value: DateFormat.jm().format(widget.breakEnd),
              ),
              DetailsRecord(
                label: 'Shift End Time',
                value: DateFormat.jm().format(widget.shiftEnd),
              ),
              GroupTitle(title: 'Job Information'),
              DetailsRecord(
                label: 'Jobsite',
                value: widget.jobsite,
              ),
              DetailsRecord(
                label: 'Site Manager',
                value: widget.clientContact,
              ),
              DetailsRecord(
                label: 'Address',
                value: widget.address,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
