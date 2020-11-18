import 'package:flutter/material.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/screens/more_button.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/list_service.dart';
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
    ListService jobOfferListService =
        ListService(action: jobOfferService.getCandidateJobOffers);
    ListService timesheetListService =
        ListService(action: timesheetService.getNotificationTimesheets);

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
            StreamBuilder(
              stream: jobOfferListService.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<JobOffer> data = snapshot.data;

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
                          isShow: jobOfferListService.canFetchMore,
                          stream: jobOfferListService.fetchStream,
                          onPressed: () => jobOfferListService.fetchMore(),
                        );
                      }
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
                  return Container(
                    child: Text('Something went wrong!'),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            StreamBuilder(
              stream: timesheetListService.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Timesheet> data = snapshot.data;

                  if (data.length == 0) {
                    return Center(
                      child: Text('No Data'),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == data.length) {
                        return MoreButton(
                          isShow: timesheetListService.canFetchMore,
                          stream: timesheetListService.fetchStream,
                          onPressed: () => timesheetListService.fetchMore(),
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
                          status: timesheet.status,
                          id: timesheet.id,
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
          ],
        ),
      ),
    );
  }
}
