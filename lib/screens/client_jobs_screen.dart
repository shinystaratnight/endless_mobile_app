import 'package:flutter/material.dart';
import 'package:piiprent/models/job_model.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/client_job_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';

class ClientJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobService jobService = Provider.of<JobService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Jobs')),
      drawer: ClientDrawer(),
      body: ListPage<Job>(
        action: jobService.getClientJobs,
        params: {
          'role': loginService.user.activeRole.id,
        },
        getChild: (Job instance, Function reset) {
          return ClientJobCard(
            job: instance,
          );
        },
      ),
    );
  }
}
