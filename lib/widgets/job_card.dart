import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/screens/candidate_job_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';

class JobCard extends StatelessWidget {
  final String company;
  final String position;
  final DateTime date;
  final String location;

  final bool offer;

  JobCard(
      {this.company,
      this.position,
      this.date,
      this.location,
      this.offer = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CandidateJobDetailsScreen(
            company: company,
            position: position,
          ),
        ),
      ),
      child: ListCard(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company,
              style: TextStyle(fontSize: 22.0, color: Colors.white),
            ),
            Text(
              position,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            ListCardRecord(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.access_time, color: Colors.blueAccent),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        DateFormat.jm().format(date),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(date),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListCardRecord(
              last: true,
              content: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blueAccent,
                  ),
                  Text(
                    location,
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            offer
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  width: 1.0,
                                  color: Colors.blueAccent,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () => {},
                                    icon: Icon(Icons.close),
                                    color: Colors.redAccent),
                                SizedBox(
                                  width: 15.0,
                                ),
                                IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.greenAccent,
                                  onPressed: () => {},
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
