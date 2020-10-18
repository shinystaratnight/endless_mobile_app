import 'package:flutter/material.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/home_calendar.dart';
import 'package:piiprent/widgets/home_screen_button.dart';
import 'package:piiprent/widgets/page_container.dart';

class CandidateHomeScreen extends StatefulWidget {
  @override
  _CandidateHomeScreenState createState() => _CandidateHomeScreenState();
}

class _CandidateHomeScreenState extends State<CandidateHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CandidateDrawer(),
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
                        color: Colors.blueAccent,
                        icon: Icon(
                          Icons.person,
                          color: Colors.blueAccent,
                        ),
                        path: '/candidate_profile',
                        text: 'Profile',
                      )),
                  Expanded(
                      flex: 1,
                      child: HomeScreenButton(
                        color: Colors.orangeAccent,
                        icon: Icon(
                          Icons.local_offer,
                          color: Colors.orangeAccent,
                        ),
                        path: '/candidate_job_offers',
                        text: 'Job Offers',
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: HomeScreenButton(
                      color: Colors.yellowAccent,
                      icon: Icon(
                        Icons.business_center,
                        color: Colors.yellowAccent,
                      ),
                      path: '/candidate_jobs',
                      text: 'Jobs',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: HomeScreenButton(
                      color: Colors.greenAccent,
                      icon: Icon(
                        Icons.query_builder,
                        color: Colors.greenAccent,
                      ),
                      path: '/candidate_timesheets',
                      text: 'Timesheets',
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
