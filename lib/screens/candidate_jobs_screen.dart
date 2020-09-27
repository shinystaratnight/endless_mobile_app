import 'package:flutter/material.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/job_card.dart';

class CandidateJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCandidateAppBar('Jobs', context),
      drawer: CandidateDrawer(),
      body: ListView.builder(
        itemCount: 20,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => Column(
          children: [
            JobCard(
              company: 'Some Company',
              date: DateTime.parse('2020-03-17T12:00:00+02:00'),
              location: 'Some Location',
              position: 'Some Position',
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
