import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/screens/candidate_job_details_screen.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:provider/provider.dart';

class JobCard extends StatefulWidget {
  final String company;
  final String position;
  final DateTime date;
  final String location;
  final String id;
  final String longitude;
  final String latitude;
  final String clientContact;
  final Function update;

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
    this.update,
  });

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _fetching = false;

  _acceptJobOffer(JobOfferService jobOfferService,
      NotificationService notificationService) async {
    setState(() {
      _fetching = true;
    });
    try {
      await jobOfferService.accept(widget.id);
      await notificationService.checkJobOfferNotifications();

      if (widget.update != null) {
        widget.update();
      }
    } catch (e) {
      print(e);
      setState(() {
        _fetching = false;
      });
    }
  }

  _declineJobOffer(JobOfferService jobOfferService,
      NotificationService notificationService) async {
    setState(() {
      _fetching = true;
    });
    try {
      await jobOfferService.decline(widget.id);
      await notificationService.checkJobOfferNotifications();

      if (widget.update != null) {
        widget.update();
      }
    } catch (e) {
      print(e);
      setState(() {
        _fetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);
    NotificationService notificationService =
        Provider.of<NotificationService>(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CandidateJobDetailsScreen(
            company: widget.company,
            position: widget.position,
            longitude: widget.longitude,
            lantitude: widget.latitude,
            date: widget.date,
            clientContact: widget.clientContact,
          ),
        ),
      ),
      child: ListCard(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.company,
              style: TextStyle(fontSize: 22.0, color: Colors.white),
            ),
            Text(
              widget.position,
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
                        DateFormat.jm().format(widget.date),
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
                        DateFormat('dd/MM/yyyy').format(widget.date),
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
                    widget.location,
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            widget.offer
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
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: _fetching
                                      ? null
                                      : () => _declineJobOffer(
                                            jobOfferService,
                                            notificationService,
                                          ),
                                  icon: Icon(Icons.close),
                                  color: Colors.redAccent,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.greenAccent,
                                  onPressed: _fetching
                                      ? null
                                      : () => _acceptJobOffer(
                                            jobOfferService,
                                            notificationService,
                                          ),
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
