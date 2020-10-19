import 'package:flutter/material.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:provider/provider.dart';

class CandidateJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobService jobService = Provider.of<JobService>(context);

    return Scaffold(
      appBar: getCandidateAppBar('Jobs', context),
      drawer: CandidateDrawer(),
      body: FutureBuilder(
        future: jobService.getCandidateJobs(),
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
