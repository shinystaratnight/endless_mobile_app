import 'package:flutter/material.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';

class CandidateJobOffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);

    return Scaffold(
      appBar: getCandidateAppBar('Job Offers', context),
      drawer: CandidateDrawer(),
      body: ListPage<JobOffer>(
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
            tags: instance.tags,
          );
        },
      ),
    );
  }
}
