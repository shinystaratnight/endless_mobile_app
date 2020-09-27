import 'package:flutter/material.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/timesheet_card.dart';

class CandidateTimesheetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCandidateAppBar('Timesheets', context),
      drawer: CandidateDrawer(),
      floatingActionButton: FilterDialogButton(),
      body: ListView.builder(
        itemCount: 20,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => Column(
          children: [
            TimesheetCard(
              company: 'Smart Builder Ltd',
              position: 'Brick / blocklayer',
              clientContact: 'Project Manager Duncan Pallar',
              address: 'Some address',
              shiftDate: DateTime.now(),
              shiftStart: DateTime.now(),
              shiftEnd: DateTime.now(),
              breakStart: DateTime.now(),
              breakEnd: DateTime.now(),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
