import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/screens/candidate_job_offers_screen.dart';
import 'package:piiprent/screens/candidate_jobs_screen.dart';
import 'package:piiprent/screens/candidate_profile_screen.dart';
import 'package:piiprent/screens/candidate_timesheets_screen.dart';
import 'package:piiprent/screens/forgot_password_screen.dart';

import 'package:piiprent/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Piiprent',
        theme: new ThemeData(
            accentColor: Colors.blueAccent,
            scaffoldBackgroundColor: Colors.grey[100],
            textTheme: GoogleFonts.sourceSansProTextTheme(
                Theme.of(context).textTheme)),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginScreen(),
          '/candidate_home': (BuildContext context) => CandidateHomeScreen(),
          '/candidate_jobs': (BuildContext context) => CandidateJobsScreen(),
          '/candidate_job_offers': (BuildContext context) =>
              CandidateJobOffersScreen(),
          '/candidate_timesheets': (BuildContext context) =>
              CandidateTimesheetsScreen(),
          '/candidate_profile': (BuildContext context) =>
              CandidateProfileScreen(),
          '/forgot_password': (BuildContext context) => ForgotPasswordScreen(),
        },
        home: LoginScreen());
  }
}
