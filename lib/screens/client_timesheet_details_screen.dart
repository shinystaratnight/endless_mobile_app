import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/evaluate.dart';
import 'package:piiprent/widgets/group_title.dart';

class ClientTimesheetDetailsScreen extends StatefulWidget {
  final String position;

  ClientTimesheetDetailsScreen({this.position});

  @override
  _ClientTimesheetDetailsScreenState createState() =>
      _ClientTimesheetDetailsScreenState();
}

class _ClientTimesheetDetailsScreenState
    extends State<ClientTimesheetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timesheet')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://picsum.photos/200/300'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Mr. Peter Hokke',
                style: TextStyle(fontSize: 26.0, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.position,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              GroupTitle(title: 'Times'),
              DetailsRecord(
                label: 'Shift Date',
                value: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              ),
              DetailsRecord(
                label: 'Shift Start Time',
                value: DateFormat.jm().format(DateTime.now()),
              ),
              DetailsRecord(
                label: 'Break Start Time',
                value: DateFormat.jm().format(DateTime.now()),
              ),
              DetailsRecord(
                label: 'Break End Time',
                value: DateFormat.jm().format(DateTime.now()),
              ),
              DetailsRecord(
                label: 'Shift End Time',
                value: DateFormat.jm().format(DateTime.now()),
              ),
              DetailsRecord(
                label: 'Jobsite',
                value: 'Smart Builders Ltd - Tartu',
              ),
              Evaluate(
                active: false,
                score: 3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
