import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/screens/candidate_job_offers_screen.dart';
import 'package:piiprent/screens/candidate_jobs_screen.dart';
import 'package:piiprent/screens/candidate_profile_screen.dart';
import 'package:piiprent/screens/candidate_timesheets_screen.dart';
import 'package:piiprent/screens/forgot_password_screen.dart';
import 'package:piiprent/services/industry_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

import 'package:piiprent/screens/login_screen.dart';

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<IndustryService>(create: (_) => IndustryService()),
        // Provider<LoginService>(create: (_) => LoginService())
      ],
      child: MyApp(),
    ),
  );
}

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
