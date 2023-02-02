import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/job_model.dart';
import 'package:piiprent/screens/client_job_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:piiprent/widgets/size_config.dart';

class ClientJobCard extends StatelessWidget {
  final Job job;

  ClientJobCard({
    this.job,
  });

  Widget _buildStatus(String label, JobStatus status) {
    IconData icon;
    Color color;

    // switch (status) {
    //   case JobStatus.Unfilled:
    //     {
    //       icon = Icons.close;
    //       color = Colors.red[400];
    //       break;
    //     }
    //   case JobStatus.Fullfilled:
    //     {
    //       icon = Icons.check_circle;
    //       color = Colors.green[400];
    //       break;
    //     }
    //   default:
    //     {
    //       icon = Icons.remove_circle;
    //       color = Colors.grey[400];
    //     }
    // }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 0.97,
        //horizontal:4.0,
      ),
      padding: EdgeInsets.symmetric(
        // horizontal: 8.0,
        // vertical: 4.0,
        horizontal: SizeConfig.widthMultiplier * 1.94,
        vertical: SizeConfig.textMultiplier * 0.58,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.all(
          //Radius.circular(4.0),
          Radius.circular(SizeConfig.textMultiplier * 0.58),
        ),
      ),
      child: Row(
        children: [
          Text(
            translate('timesheet.status'),
            style: TextStyle(
              //fontSize: 13,
              fontSize: SizeConfig.heightMultiplier * 1.90,
            ),
          ),
          SizedBox(
            //width: 4.0,
            width: SizeConfig.widthMultiplier * 0.97,
          ),
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
          ),
          Icon(
            icon,
            color: color,
            //size: 20.0,
            size: SizeConfig.heightMultiplier * 2.93,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClientJobDetailsScreen(
            position: job.translations['position']['en'],
            jobsite: job.jobsite,
            workStartDate: job.workStartDate,
            notes: job.notes,
            tags: job.tags,
            id: job.id,
            contact: job.contact,
          ),
        ),
      ),
      child: Column(
        children: [
          ListCard(
            header: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  job.jobsite,
                  style: TextStyle(
                    //fontSize: 18.0,
                    fontSize: SizeConfig.textMultiplier * 2.64,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                ListCardRecord(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('job.supervisor'),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        job.contact,
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                ),
                ListCardRecord(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('job.address'),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        job.address,
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                ),
                ListCardRecord(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${translate('field.start_date')}:",
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(job.workStartDate),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                ),
                ListCardRecord(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       translate('job.workers'),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        job.workers.toString(),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                ),
                ListCardRecord(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('job.position'),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        job.translations['position']['en'],
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                ),
                ListCardRecord(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('job.status'),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        job.status,
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
