import 'package:flutter/material.dart';
import 'package:piiprent/models/jobsite_model.dart';
import 'package:piiprent/services/jobsite_service.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/jobsite_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';

class ClientJobsitesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobsiteService jobsiteService = Provider.of<JobsiteService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Jobsites')),
      drawer: ClientDrawer(),
      body: ListPage<Jobsite>(
        action: jobsiteService.getJobsites,
        getChild: (Jobsite instance, Function reset) {
          return JobsiteCard(
            jobsite: instance,
          );
        },
      ),
    );
  }
}
