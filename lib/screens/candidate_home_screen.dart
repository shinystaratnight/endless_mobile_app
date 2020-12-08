import 'package:flutter/material.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/home_calendar.dart';
import 'package:piiprent/widgets/home_screen_button.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';

class CandidateHomeScreen extends StatefulWidget {
  @override
  _CandidateHomeScreenState createState() => _CandidateHomeScreenState();
}

class _CandidateHomeScreenState extends State<CandidateHomeScreen> {
  TimesheetService _timesheetService = TimesheetService();

  _getActiveTimesheet() async {
    List<Map<String, dynamic>> activeTimesheets =
        await _timesheetService.getActiveTimeheets();

    if (activeTimesheets != null && activeTimesheets.length > 0) {
      print(activeTimesheets);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('activeTimesheets', json.encode(activeTimesheets));
    }

    BackgroundFetch.start();
  }

  _initBackgroundFetch() async {}

  @override
  void initState() {
    super.initState();

    _getActiveTimesheet();
    _initBackgroundFetch();
  }

  @override
  Widget build(BuildContext context) {
    NotificationService notificationService =
        Provider.of<NotificationService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

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
              HomeCalendar(
                type: CalendarType.Canddate,
                userId: loginService.user.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
