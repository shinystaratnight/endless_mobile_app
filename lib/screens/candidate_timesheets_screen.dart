import 'package:flutter/material.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/screens/more_button.dart';
import 'package:piiprent/services/list_service.dart';
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
    ListService listService =
        ListService(action: timesheetService.getCandidateTimesheets);

    return Scaffold(
      appBar: getCandidateAppBar('Timesheets', context),
      drawer: CandidateDrawer(),
      floatingActionButton: FilterDialogButton(
        onClose: (data) {
          listService.updateParams({
            "shift_started_at_0": data['from'],
            "shift_started_at_1": data['to'],
          }, true);
        },
      ),
      body: StreamBuilder(
        stream: listService.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Timesheet> data = snapshot.data;

            if (data.length == 0) {
              return Center(
                child: Text('No Data'),
              );
            }

            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == data.length) {
                  return MoreButton(
                    isShow: listService.canFetchMore,
                    stream: listService.fetchStream,
                    onPressed: () => listService.fetchMore(),
                  );
                }

                Timesheet timesheet = data[index];

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
