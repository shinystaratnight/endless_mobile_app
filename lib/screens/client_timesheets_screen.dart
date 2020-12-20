import 'package:flutter/material.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/client_timesheet_card.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ClientTimesheetsScreen extends StatelessWidget {
  final StreamController _updateStream = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Timesheets'),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Unapproved'),
                    )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.query_builder),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('History'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: ClientDrawer(),
        floatingActionButton: FilterDialogButton(
          onClose: (data) {
            _updateStream.add({
              'shift_started_at_0': data['from'],
              'shift_started_at_1': data['to'],
            });
          },
        ),
        body: TabBarView(
          children: [
            ListPage<Timesheet>(
              action: timesheetService.getUnapprovedTimesheets,
              updateStream: _updateStream.stream,
              params: {
                'role': loginService.user.activeRole.id,
              },
              getChild: (Timesheet instance, Function reset) {
                return ClientTimesheetCard(
                  timesheet: instance,
                  update: reset,
                );
              },
            ),
            ListPage<Timesheet>(
              action: timesheetService.getHistoryTimesheets,
              updateStream: _updateStream.stream,
              params: {
                'role': loginService.user.activeRole.id,
              },
              getChild: (Timesheet instance, Function reset) {
                return ClientTimesheetCard(
                  timesheet: instance,
                  update: reset,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
