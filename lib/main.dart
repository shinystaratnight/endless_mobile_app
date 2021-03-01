import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/screens/candidate_job_offers_screen.dart';
import 'package:piiprent/screens/candidate_jobs_screen.dart';
import 'package:piiprent/screens/candidate_profile_screen.dart';
import 'package:piiprent/screens/candidate_timesheets_screen.dart';
import 'package:piiprent/screens/client_home_screen.dart';
import 'package:piiprent/screens/client_jobs_screen.dart';
import 'package:piiprent/screens/client_jobsites_screen.dart';
import 'package:piiprent/screens/client_profile_screen.dart';
import 'package:piiprent/screens/client_timesheets_screen.dart';
import 'package:piiprent/screens/forgot_password_screen.dart';
import 'package:piiprent/screens/preview_screen.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:piiprent/services/company_service.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/industry_service.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/jobsite_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:piiprent/screens/login_screen.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: [
      'en_US',
      'et',
      'fi',
      'ru',
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<IndustryService>(create: (_) => IndustryService()),
        Provider<LoginService>(create: (_) => LoginService()),
        Provider<JobOfferService>(create: (_) => JobOfferService()),
        Provider<JobService>(create: (_) => JobService()),
        Provider<TimesheetService>(create: (_) => TimesheetService()),
        Provider<ContactService>(create: (_) => ContactService()),
        Provider<CandidateService>(create: (_) => CandidateService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
        Provider<CompanyService>(create: (_) => CompanyService()),
        Provider<JobsiteService>(create: (_) => JobsiteService()),
      ],
      child: LocalizedApp(delegate, MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Piiprent',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: new ThemeData(
          accentColor: Colors.blueAccent,
          scaffoldBackgroundColor: Colors.grey[100],
          textTheme:
              GoogleFonts.sourceSansProTextTheme(Theme.of(context).textTheme),
        ),
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
          '/client_home': (BuildContext context) => ClientHomeScreen(),
          '/client_profile': (BuildContext context) => ClientProfileScreen(),
          '/client_jobs': (BuildContext context) => ClientJobsScreen(),
          '/client_timesheets': (BuildContext context) =>
              ClientTimesheetsScreen(),
          '/client_jobsites': (BuildContext context) => ClientJobsitesScreen(),
          '/forgot_password': (BuildContext context) => ForgotPasswordScreen(),
        },
        home: PreviewScreen(),
      ),
    );
  }
}
