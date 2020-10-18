import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/group_title.dart';

class ClientJobDetailsScreen extends StatefulWidget {
  final String position;
  final String jobsite;

  ClientJobDetailsScreen({this.position, this.jobsite});

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

  Widget _buildTable(dynamic data) {
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
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                _buildTableCell('Date'),
                _buildTableCell('Start Time'),
                _buildTableCell('Workers'),
                _buildTableCell('Status'),
              ],
            ),
            TableRow(
              children: [
                _buildTableCell('15/02/2020'),
                _buildTableCell('02:20 PM'),
                _buildTableCell('1'),
                _buildTableCell('Fulfilled', Colors.green),
              ],
            ),
            TableRow(
              children: [
                _buildTableCell('15/02/2020'),
                _buildTableCell('02:20 PM'),
                _buildTableCell('1'),
                _buildTableCell('Unfulfilled', Colors.red),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job')),
      floatingActionButton: FilterDialogButton(),
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
              GroupTitle(title: 'Job information'),
              SizedBox(
                height: 15.0,
              ),
              DetailsRecord(label: 'Site Supervisor', value: 'Client contact'),
              DetailsRecord(
                label: 'Shift Date',
                value: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              ),
              DetailsRecord(
                label: 'Shift Starting Time',
                value: DateFormat.jm().format(DateTime.now()),
              ),
              DetailsRecord(label: 'Note', value: ''),
              SizedBox(
                height: 15.0,
              ),
              _buildTable({})
            ],
          ),
        ),
      ),
    );
  }
}
