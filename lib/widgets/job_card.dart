import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/screens/candidate_job_details_screen.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:provider/provider.dart';

class JobCard extends StatelessWidget {
  final String company;
  final String position;
  final DateTime date;
  final String location;
  final String id;
  final String longitude;
  final String latitude;
  final String clientContact;

  final bool offer;

  JobCard({
    this.company,
    this.position,
    this.date,
    this.location,
    this.id,
    this.longitude,
    this.latitude,
    this.clientContact,
    this.offer = false,
  });

  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CandidateJobDetailsScreen(
            company: company,
            position: position,
            longitude: longitude,
            lantitude: latitude,
            date: date,
            clientContact: clientContact,
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
                      Icon(
                        Icons.access_time,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        DateFormat.jm().format(date),
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(date),
                        style: TextStyle(color: Colors.blue),
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
                    color: Colors.blue,
                  ),
                  Text(
                    location,
                    style: TextStyle(color: Colors.blue),
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
                                  color: Colors.blue,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => jobOfferService.accept(id),
                                  icon: Icon(Icons.close),
                                  color: Colors.redAccent,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.greenAccent,
                                  onPressed: () => jobOfferService.decline(id),
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
