import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/screens/client_timesheet_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';

class ClientTimesheetCard extends StatelessWidget {
  // final String id;
  // final String score;
  // final String position;
  // final String candidateContact;
  // final String src;
  // final String jobsite;
  // final DateTime shiftDate;
  // final DateTime shiftStart;
  // final DateTime shiftEnd;
  // final DateTime breakStart;
  // final DateTime breakEnd;
  // final int status;
  // final bool signatureScheme;
  final Timesheet timesheet;

  ClientTimesheetCard({
    this.timesheet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClientTimesheetDetailsScreen(
            timesheet: timesheet,
          ),
        ),
      ),
      child: ListCard(
        header: Row(
          children: [
            Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: timesheet.candidateAvatarUrl != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(timesheet.candidateAvatarUrl),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 16.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timesheet.candidateName,
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Text(
                  'Position - ${timesheet.position}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14.0,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        timesheet.score,
                        style: TextStyle(color: Colors.amber),
                      )
                    ],
                  ),
                ),
                timesheet.signatureScheme
                    ? Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '(Signature required)',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : SizedBox(),
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
                        DateFormat('dd/MM/yyyy').format(timesheet.shiftStart),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        DateFormat.jm().format(timesheet.shiftStart),
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
                        DateFormat.jm().format(timesheet.breakStart),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'to',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        DateFormat.jm().format(timesheet.breakEnd),
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
                        DateFormat.jm().format(timesheet.shiftEnd),
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
