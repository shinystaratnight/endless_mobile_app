import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';

import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CandidateJobDetailsScreen extends StatefulWidget {
  final String position;
  final String company;
  final String longitude;
  final String latitude;
  final DateTime date;
  final String clientContact;
  final List<dynamic> tags;

  CandidateJobDetailsScreen({
    this.position,
    this.company,
    this.longitude,
    this.latitude,
    this.date,
    this.clientContact,
    this.tags,
  });

  @override
  _CandidateJobDetailsScreenState createState() =>
      _CandidateJobDetailsScreenState();
}

class _CandidateJobDetailsScreenState extends State<CandidateJobDetailsScreen> {
  GoogleMapController _mapController;
  Location _location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  int _id = 1;

  void _add(double latitude, double longitude) {
    final MarkerId markerId = MarkerId(_id.toString());

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latitude,
        longitude,
      ),
    );

    setState(() {
      markers[markerId] = marker;
      _id = _id + 1;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _add(
      double.parse(widget.latitude),
      double.parse(widget.longitude),
    );
  }

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
              // TODO: Add tags
              // GroupTitle(title: 'Tags'),
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
                onPressed: () async {
                  try {
                    LocationData data = await _location.getLocation();

                    _add(data.latitude, data.longitude);
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(data.latitude, data.longitude),
                          zoom: 15,
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              SizedBox(
                height: 350.0,
                width: 20.0,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(widget.latitude),
                      double.parse(widget.longitude),
                    ),
                    zoom: 13.0,
                  ),
                  markers: Set<Marker>.of(markers.values),
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
}
