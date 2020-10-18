import 'package:flutter/material.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/client_job_card.dart';

class ClientJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jobs')),
      drawer: ClientDrawer(),
      body: ListView.builder(
        itemCount: 20,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => Column(
          children: [
            ClientJobCard(
              jobsite: 'Smart Builders Ltd - Tartu',
              status: 'Confirmed',
              contact: 'Project Manager Mr. Duncan Pallar',
              position: 'Brick/blocklayer',
              today: true,
              tomorrow: false,
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
