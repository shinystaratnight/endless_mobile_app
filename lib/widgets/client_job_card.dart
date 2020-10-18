import 'package:flutter/material.dart';
import 'package:piiprent/screens/client_job_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';

class ClientJobCard extends StatelessWidget {
  final String jobsite;
  final String contact;
  final String status;
  final String position;
  final bool today;
  final bool tomorrow;

  ClientJobCard(
      {this.jobsite,
      this.contact,
      this.status,
      this.position,
      this.today,
      this.tomorrow});

  Widget _buildStatus(String label, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        children: [
          Text('Status:'),
          SizedBox(
            width: 4.0,
          ),
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Icon(
            active ? Icons.check_circle : Icons.remove_circle,
            color: active ? Colors.green : Colors.grey,
            size: 20.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClientJobDetailsScreen(
            position: position,
            jobsite: jobsite,
          ),
        ),
      ),
      child: ListCard(
        header: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobsite,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  contact,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Workers',
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      Container(
                        height: 20.0,
                        width: 20.0,
                        margin: const EdgeInsets.only(left: 8.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Text('2', style: TextStyle(color: Colors.blue)),
                      )
                    ],
                  ),
                ],
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
                  Text('Position'),
                  Text(position),
                ],
              ),
            ),
            ListCardRecord(
              last: true,
              content: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildStatus('Today', today),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildStatus(
                      'Tomorrow',
                      tomorrow,
                    ),
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
