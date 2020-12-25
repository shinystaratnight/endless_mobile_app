import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/screens/candidate_timesheet_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';

class TimesheetCard extends StatelessWidget {
  final String company;
  final String position;
  final String clientContact;
  final String address;
  final String jobsite;
  final DateTime shiftDate;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final DateTime breakStart;
  final DateTime breakEnd;
  final int status;
  final String id;
  final Function update;

  TimesheetCard({
    this.company,
    this.position,
    this.clientContact,
    this.address,
    this.jobsite,
    this.shiftDate,
    this.shiftStart,
    this.shiftEnd,
    this.breakStart,
    this.breakEnd,
    this.status,
    this.id,
    this.update,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CandidateTimesheetDetailsScreen(
              position: position,
              jobsite: jobsite,
              clientContact: clientContact,
              address: address,
              shiftDate: shiftDate,
              shiftStart: shiftStart,
              shiftEnd: shiftEnd,
              breakStart: breakStart,
              breakEnd: breakEnd,
              status: status,
              id: id,
            ),
          ),
        );

        if (result) {
          update();
        }
      },
      child: ListCard(
        header: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '${TimesheetStatus[status]}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: status == 3 ? Colors.red[300] : Colors.green[300],
                    ),
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Text(
                  clientContact,
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      address,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ],
            )
          ],
        ),
        body: Column(
          children: [
            ListCardRecord(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shift Started At',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(shiftDate),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        DateFormat.jm().format(shiftStart),
                        style: TextStyle(color: Colors.blueAccent),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListCardRecord(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Break',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat.jm().format(breakStart),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'to',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        DateFormat.jm().format(breakEnd),
                        style: TextStyle(color: Colors.blueAccent),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListCardRecord(
              last: true,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shift Ended At',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat.jm().format(shiftEnd),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
