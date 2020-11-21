import 'package:flutter/material.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:piiprent/widgets/timesheet_card.dart';
import 'package:provider/provider.dart';

class CandidateNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: getCandidateAppBar('Notifications', context,
            tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.local_offer),
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
                    Icon(Icons.query_builder),
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
            ListPage<JobOffer>(
              action: jobOfferService.getCandidateJobOffers,
              getChild: (JobOffer instance, Function reset) {
                return JobCard(
                  company: instance.company,
                  date: instance.datetime,
                  location: instance.location,
                  position: instance.position,
                  id: instance.id,
                  longitude: instance.longitude,
                  latitude: instance.latitude,
                  clientContact: instance.clientContact,
                  offer: true,
                  update: reset,
                );
              },
            ),
            ListPage<Timesheet>(
              action: timesheetService.getNotificationTimesheets,
              getChild: (Timesheet instance, Function reset) {
                return TimesheetCard(
                  company: instance.company,
                  position: instance.position,
                  clientContact: instance.clientContact,
                  jobsite: instance.jobsite,
                  address: instance.address,
                  shiftDate: instance.shiftStart,
                  shiftStart: instance.shiftStart,
                  shiftEnd: instance.shiftEnd,
                  breakStart: instance.breakStart,
                  breakEnd: instance.breakEnd,
                  status: instance.status,
                  id: instance.id,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
