import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/shift_model.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/login_service.dart';

import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:provider/provider.dart';

class ClientJobDetailsScreen extends StatefulWidget {
  final String position;
  final String jobsite;
  final DateTime workStartDate;
  final String notes;
  final List<dynamic> tags;
  final String id;
  final String contact;

  ClientJobDetailsScreen({
    this.position,
    this.jobsite,
    this.workStartDate,
    this.notes,
    this.tags,
    this.id,
    this.contact,
  });

  @override
  _ClientJobDetailsScreenState createState() => _ClientJobDetailsScreenState();
}

class _ClientJobDetailsScreenState extends State<ClientJobDetailsScreen> {
  Widget _buildTableCell(String text, [Color color = Colors.black]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 16.0),
      ),
    );
  }

  Widget _buildTable(List<Shift> data) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            'Shifts',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colors.grey,
            ),
          ),
          children: data.asMap().entries.map((e) {
            int i = e.key;
            Shift shift = e.value;

            if (i == 0) {
              return TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: [
                  _buildTableCell('Date'),
                  _buildTableCell('Start Time'),
                  _buildTableCell('Workers'),
                  _buildTableCell('Status'),
                ],
              );
            }

            return TableRow(
              children: [
                _buildTableCell(
                    DateFormat('dd/MM/yyyy').format(shift.datetime)),
                _buildTableCell(DateFormat.jm().format(shift.datetime)),
                _buildTableCell(shift.workers.toString()),
                _buildTableCell(
                  shift.isFulfilled ? 'Fulfilled' : 'Unfulfilled',
                  shift.isFulfilled ? Colors.green[400] : Colors.red[400],
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    JobService jobService = Provider.of<JobService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Job')),
      floatingActionButton: FilterDialogButton(
        onClose: (_) {},
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 25.0,
              ),
              Text(
                widget.position,
                style: TextStyle(fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.jobsite,
                style: TextStyle(fontSize: 18.0, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              GroupTitle(title: 'Tags'),
              Text(widget.tags.reduce((value, element) => '$value, $element')),
              GroupTitle(title: 'Job information'),
              SizedBox(
                height: 15.0,
              ),
              DetailsRecord(label: 'Site Supervisor', value: widget.contact),
              DetailsRecord(
                label: 'Shift Date',
                value: DateFormat('dd/MM/yyyy').format(widget.workStartDate),
              ),
              DetailsRecord(
                label: 'Shift Starting Time',
                value: DateFormat.jm().format(widget.workStartDate),
              ),
              DetailsRecord(label: 'Note', value: widget.notes),
              SizedBox(
                height: 15.0,
              ),
              FutureBuilder(
                future: jobService.getShifts({
                  'job': widget.id,
                  'client_contact': loginService.user.id,
                }),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Has Error'),
                    );
                  }

                  return _buildTable(snapshot.data['list']);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
