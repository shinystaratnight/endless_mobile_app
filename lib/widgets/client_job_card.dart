import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
          Radius.circular( SizeConfig.textMultiplier * 0.58),
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
      child: ListCard(
        header: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                    height: SizeConfig.textMultiplier * 1.17,
                    //height: 8.0,
                  ),
                  Text(
                    job.contact,
                    style: TextStyle(
                      //fontSize: 16.0,
                      fontSize: SizeConfig.textMultiplier * 2.34,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 1.94,
                        vertical: SizeConfig.textMultiplier * 0.29,
                        // horizontal: 8.0,
                        // vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            //14.0,
                            SizeConfig.heightMultiplier * 2.05,
                          ),
                        ),
                      ),
                      child: Text(
                        job.status,
                        style: TextStyle(
                          //fontSize: 14.0,
                          fontSize: SizeConfig.heightMultiplier * 2.05,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.textMultiplier * 1.17,
                      //height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          translate('table.workers'),
                          style: TextStyle(
                            //fontSize: 14.0,
                            fontSize: SizeConfig.heightMultiplier * 2.05,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: SizeConfig.heightMultiplier * 2.93,
                          width: SizeConfig.widthMultiplier * 4.87,
                          // height: 20.0,
                          // width: 20.0,
                          //margin: const EdgeInsets.only(left: 8.0),
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier * 1.94,),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              //25.0,
                              SizeConfig.heightMultiplier * 3.66,
                            ),
                          ),
                          child: Text(
                            job.workers.toString(),
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: SizeConfig.heightMultiplier * 2.34,),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
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
                    translate('timesheet.position'),
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
           /* ListCardRecord(
              last: true,
              content: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildStatus(
                      'Today',
                      job.isFulFilledToday,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildStatus(
                      'Tomorrow',
                      job.isFulfilled,
                    ),
                  )
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
