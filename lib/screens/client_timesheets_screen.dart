import 'package:flutter/material.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/client_timesheet_card.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';

class ClientTimesheetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Timesheets'),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Unapproved'),
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('History'),
                      )
                    ],
                  ),
                ),
              ],
            )),
        drawer: ClientDrawer(),
        floatingActionButton: FilterDialogButton(
          onClose: (_) {},
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: 20,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => Column(
                children: [
                  ClientTimesheetCard(
                    score: '4.8',
                    position: 'Brick / blocklayer',
                    candidateContact: 'Mr. Peter Hokke',
                    src: 'https://picsum.photos/200/300',
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
            ListView.builder(
              itemCount: 20,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => Column(
                children: [
                  ClientTimesheetCard(
                    score: '4.8',
                    position: 'Brick / blocklayer',
                    candidateContact: 'Mr. Peter Hokke',
                    src: 'https://picsum.photos/200/300',
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
          ],
        ),
      ),
    );
  }
}
