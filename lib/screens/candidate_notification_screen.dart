import 'package:flutter/material.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/job_card.dart';
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
            FutureBuilder(
              future: jobOfferService.getCandidateJobOffers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<JobOffer> data = snapshot.data;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      JobOffer offer = data[index];

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: JobCard(
                          company: offer.company,
                          date: offer.datetime,
                          location: offer.location,
                          position: offer.position,
                          id: offer.id,
                          longitude: offer.longitude,
                          latitude: offer.latitude,
                          clientContact: offer.clientContact,
                          offer: true,
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
            FutureBuilder(
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
          ],
        ),
      ),
    );
  }
}
