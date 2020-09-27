import 'package:flutter/material.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:piiprent/widgets/timesheet_card.dart';

class CandidateNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: getCandidateAppBar('Notifications', context,
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.school),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Job Offers'),
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.school),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Timesheets'),
                      )
                    ],
                  ),
                ),
              ],
              showNotification: false),
          body: TabBarView(
            children: [
              ListView.builder(
                itemCount: 20,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => Column(
                  children: [
                    JobCard(
                      company: 'Some Company',
                      date: DateTime.parse('2020-03-17T12:00:00+02:00'),
                      location: 'Some Location',
                      position: 'Some Position',
                      offer: true,
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
            ],
          )),
    );
  }
}
