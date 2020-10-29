import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'dart:async';

import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CandidateJobDetailsScreen extends StatefulWidget {
  final String position;
  final String company;
  final String longitude;
  final String lantitude;
  final DateTime date;
  final String clientContact;

  CandidateJobDetailsScreen({
    this.position,
    this.company,
    this.longitude,
    this.lantitude,
    this.date,
    this.clientContact,
  });

  @override
  _CandidateJobDetailsScreenState createState() =>
      _CandidateJobDetailsScreenState();
}

class _CandidateJobDetailsScreenState extends State<CandidateJobDetailsScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 6,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCandidateAppBar('Job', context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 25.0,
              ),
              Text(
                widget.position,
                style: TextStyle(fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.company,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              GroupTitle(title: 'Tags'),
              GroupTitle(title: 'Job information'),
              SizedBox(
                height: 15.0,
              ),
              DetailsRecord(
                label: 'Site Supervisor',
                value: widget.clientContact,
              ),
              DetailsRecord(
                label: 'Shift Date',
                value: DateFormat('dd/MM/yyyy').format(widget.date),
              ),
              DetailsRecord(
                label: 'Shift Starting Time',
                value: DateFormat.jm().format(widget.date),
              ),
              DetailsRecord(label: 'Note', value: ''),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                color: Colors.white,
                child: Text('Direct me'),
                onPressed: () {},
              ),
              SizedBox(
                height: 350.0,
                width: 20.0,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(widget.lantitude),
                      double.parse(widget.longitude),
                    ),
                    zoom: 4.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
