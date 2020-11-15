import 'package:flutter/material.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/list_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:provider/provider.dart';

class CandidateJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobService jobService = Provider.of<JobService>(context);
    ListService listService = ListService(action: jobService.getCandidateJobs);

    return Scaffold(
      appBar: getCandidateAppBar('Jobs', context),
      drawer: CandidateDrawer(),
      body: StreamBuilder(
        stream: listService.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<JobOffer> data = snapshot.data;

            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == data.length) {
                  return listService.canFetchMore
                      ? StreamBuilder(
                          stream: listService.fetchStream,
                          builder: (context, snapshot) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: snapshot.hasData && snapshot.data
                                    ? CircularProgressIndicator()
                                    : RaisedButton(
                                        onPressed: () =>
                                            listService.fetchMore(),
                                        child: Text('Upload'),
                                      ),
                              ),
                            );
                          },
                        )
                      : SizedBox();
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
