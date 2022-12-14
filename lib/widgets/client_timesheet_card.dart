import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/screens/client_timesheet_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:piiprent/widgets/size_config.dart';

class ClientTimesheetCard extends StatelessWidget {
  final Timesheet timesheet;
  final Function update;

  ClientTimesheetCard({
    this.timesheet,
    this.update,
  });

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return GestureDetector(
      onTap: () async {
        var result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientTimesheetDetailsScreen(
              timesheet: timesheet,
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
              children: [
                Container(
                  // height: 70,
                  // width: 70,
                  height: SizeConfig.heightMultiplier * 10.25,
                  width: SizeConfig.widthMultiplier * 17.03,
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
              // width: 16.0,
              width: SizeConfig.widthMultiplier * 3.89,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: SizeConfig.heightMultiplier * 3,
                  child: FittedBox(
                    child: Text(
                      timesheet.candidateName,
                      maxLines: 1,
                      style: TextStyle(
                        //fontSize: 22.0,
                        fontSize: SizeConfig.heightMultiplier * 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(
                  "${translate('timesheet.position')} - ${timesheet.position(localizationDelegate.currentLocale)}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.heightMultiplier * 2.34),
                ),
                SizedBox(
                  //height: 12.0,
                  height: SizeConfig.heightMultiplier * 1.76,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    //horizontal: 6.0,
                    horizontal: SizeConfig.widthMultiplier * 1.46,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        //8.0,
                        SizeConfig.heightMultiplier * 1.17,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        //size: 14.0,
                        size: SizeConfig.heightMultiplier * 2.05,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        //width: 4.0,
                        width: SizeConfig.widthMultiplier * 0.97,
                      ),
                      Text(
                        timesheet.score,
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: SizeConfig.heightMultiplier * 2.34),
                      )
                    ],
                  ),
                ),
                timesheet.signatureScheme && timesheet.status == 5
                    ? Container(
                        padding: EdgeInsets.only(
                          //top: 8.0,
                          top: SizeConfig.heightMultiplier * 1.17,
                        ),
                        child: Text(
                          "(${translate('timesheet.signature_required')})",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.heightMultiplier * 2.34,
                          ),
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
                    translate('timesheet.shift_started_at'),
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timesheet.shiftStart != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(timesheet.shiftStart)
                            : '-',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        timesheet.shiftStart != null
                            ? DateFormat.jm().format(timesheet.shiftStart)
                            : '-',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
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
                    translate('timesheet.break'),
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timesheet.breakStart != null
                            ? DateFormat.jm().format(timesheet.breakStart)
                            : '-',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      SizedBox(
                        //width: 5.0,
                        width: SizeConfig.widthMultiplier * 1.22,
                      ),
                      Text(
                        translate('timesheet.break_to'),
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      SizedBox(
                        //width: 5.0,
                        width: SizeConfig.widthMultiplier * 1.22,
                      ),
                      Text(
                        timesheet.breakEnd != null
                            ? DateFormat.jm().format(timesheet.breakEnd)
                            : '-',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
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
                    translate('timesheet.shift_ended_at'),
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timesheet.shiftEnd != null
                            ? DateFormat.jm().format(timesheet.shiftEnd)
                            : '-',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
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
