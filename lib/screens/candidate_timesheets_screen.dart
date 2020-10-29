import 'package:flutter/material.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/timesheet_card.dart';
import 'package:provider/provider.dart';

class CandidateTimesheetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);

    return Scaffold(
      appBar: getCandidateAppBar('Timesheets', context),
      drawer: CandidateDrawer(),
      floatingActionButton: FilterDialogButton(),
      body: FutureBuilder(
        future: timesheetService.getCandidateTimesheets(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Timesheet> data = snapshot.data;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Timesheet timesheet = data[index];

                print(timesheet.position);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TimesheetCard(
                    company: timesheet.company,
                    position: timesheet.position,
                    clientContact: timesheet.clientContact,
                    jobsite: timesheet.jobsite,
                    address: timesheet.address,
                    shiftDate: timesheet.shiftStart,
                    shiftStart: timesheet.shiftStart,
                    shiftEnd: timesheet.shiftEnd,
                    breakStart: timesheet.breakStart,
                    breakEnd: timesheet.breakEnd,
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            print(snapshot.error);

            return Container(
              child: Text('Something went wrong!'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
