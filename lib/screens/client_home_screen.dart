import 'package:flutter/material.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/home_calendar.dart';
import 'package:piiprent/widgets/home_screen_button.dart';
import 'package:piiprent/widgets/page_container.dart';

class ClientHomeScreen extends StatefulWidget {
  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ClientDrawer(),
      appBar: AppBar(title: Text('Dashboard')),
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
                        path: '/client_profile',
                        text: 'Profile',
                      )),
                  Expanded(
                    flex: 1,
                    child: HomeScreenButton(
                      color: Colors.orange[700],
                      text: 'Coming soon',
                      icon: Icon(
                        Icons.business_center,
                        color: Colors.white,
                      ),
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
                      path: '/client_jobs',
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
                      path: '/client_timesheets',
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
