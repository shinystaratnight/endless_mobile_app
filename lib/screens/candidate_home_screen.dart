import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/services/tracking_service.dart';
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
  TrackingService _trackingService = TrackingService();

  _getActiveTimesheet() async {
    List<Map<String, dynamic>> activeTimesheets =
        await _timesheetService.getActiveTimeheets();

    if (activeTimesheets != null && activeTimesheets.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('activeTimesheets', json.encode(activeTimesheets));

      return activeTimesheets;
    }

    return null;
  }

  _onBackgroundFetch(taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String activeTimesheetsEncoded =
        (prefs.getString('activeTimesheets') ?? null);

    if (activeTimesheetsEncoded == null) {
      return;
    }

    List<dynamic> activeTimeshseets = json.decode(activeTimesheetsEncoded);

    try {
      var activeTimesheet = activeTimeshseets.firstWhere((element) {
        DateTime from = DateTime.parse(element['from']);
        DateTime to = DateTime.parse(element['to']);
        DateTime now = DateTime.now().toUtc();

        return now.isAfter(from) && now.isBefore(to);
      });

      Position position = await _trackingService.getCurrentPosition();
      _trackingService.sendLocation(position, activeTimesheet['id']);
    } catch (e) {
      return null;
    } finally {
      BackgroundFetch.finish(taskId);
    }
  }

  _initBackgroundFetch(dynamic activeTimesheets) async {
    if (activeTimesheets == null) {
      return;
    }

    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: false,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      (String taskId) async {
        // This is the fetch-event callback.
        print("[BackgroundFetch] Event received $taskId");
        // IMPORTANT:  You must signal completion of your task or the OS can punish your app
        // for taking too long in the background.
        _onBackgroundFetch(taskId);
      },
    ).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    BackgroundFetch.start().then((int status) {
      print('[BackgroundFetch] start success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] start FAILURE: $e');
    });
  }

  @override
  void initState() {
    super.initState();

    // _getActiveTimesheet().then(_initBackgroundFetch);
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
