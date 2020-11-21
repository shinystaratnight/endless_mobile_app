import 'package:flutter/material.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/home_calendar.dart';
import 'package:piiprent/widgets/home_screen_button.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:provider/provider.dart';

class CandidateHomeScreen extends StatefulWidget {
  @override
  _CandidateHomeScreenState createState() => _CandidateHomeScreenState();
}

class _CandidateHomeScreenState extends State<CandidateHomeScreen> {
  @override
  Widget build(BuildContext context) {
    NotificationService notificationService =
        Provider.of<NotificationService>(context);

    return Scaffold(
      drawer: CandidateDrawer(dashboard: true),
      appBar: getCandidateAppBar('Home', context),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: HomeScreenButton(
                      color: Colors.blue[700],
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue[700],
                      ),
                      path: '/candidate_profile',
                      text: 'Profile',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: HomeScreenButton(
                      color: Colors.orange[700],
                      icon: Icon(
                        Icons.local_offer,
                        color: Colors.orange[700],
                      ),
                      path: '/candidate_job_offers',
                      text: 'Job Offers',
                      stream: notificationService.jobOfferStream,
                      update: notificationService.checkJobOfferNotifications,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: HomeScreenButton(
                      color: Colors.amber[700],
                      icon: Icon(
                        Icons.business_center,
                        color: Colors.amber[700],
                      ),
                      path: '/candidate_jobs',
                      text: 'Jobs',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: HomeScreenButton(
                      color: Colors.green[700],
                      icon: Icon(
                        Icons.query_builder,
                        color: Colors.green[700],
                      ),
                      path: '/candidate_timesheets',
                      text: 'Timesheets',
                      stream: notificationService.timesheetStream,
                      update: notificationService.checkTimesheetNotifications,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              HomeCalendar()
            ],
          ),
        ),
      ),
    );
  }
}
