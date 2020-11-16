import 'package:flutter/material.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/screens/more_button.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/list_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:provider/provider.dart';

class CandidateJobOffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);
    ListService listService =
        ListService(action: jobOfferService.getCandidateJobOffers);

    return Scaffold(
      appBar: getCandidateAppBar('Job Offers', context),
      drawer: CandidateDrawer(),
      body: StreamBuilder(
        stream: listService.stream,
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
                    isShow: listService.canFetchMore,
                    stream: listService.fetchStream,
                    onPressed: () => listService.fetchMore(),
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
    );
  }
}
