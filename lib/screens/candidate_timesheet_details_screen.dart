import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:provider/provider.dart';

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
  final int status;
  final String id;

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
    this.status,
    this.id,
  });

  @override
  _CandidateTimesheetDetailsScreenState createState() =>
      _CandidateTimesheetDetailsScreenState();
}

class _CandidateTimesheetDetailsScreenState
    extends State<CandidateTimesheetDetailsScreen> {
  bool _updated = false;
  bool _fetching = false;

  _acceptPreShiftCheck(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      bool result = await timesheetService.acceptPreShiftCheck(widget.id);

      setState(() => _updated = result);
    } catch (e) {
      print(e);
    } finally {
      setState(() => _fetching = false);
    }
  }

  _declinePreShiftCheck(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      bool result = await timesheetService.declinePreShiftCheck(widget.id);

      setState(() => _updated = result);
    } catch (e) {
      print(e);
    } finally {
      setState(() => _fetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);

    print(widget.status);
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
              widget.status == 1 && !_updated
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: Text(
                              'Confirm if you are going to work',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FormSubmitButton(
                              label: 'Decline',
                              onPressed: () =>
                                  _declinePreShiftCheck(timesheetService),
                              disabled: _fetching,
                              color: Colors.red[400],
                            ),
                            FormSubmitButton(
                              label: 'Accept',
                              onPressed: () =>
                                  _acceptPreShiftCheck(timesheetService),
                              disabled: _fetching,
                              color: Colors.green[400],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              widget.status == 4 && !_updated
                  ? FormSubmitButton(
                      label: 'Submit',
                      onPressed: () => {},
                      disabled: true,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
