import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

class CandidateJobDetailsScreen extends StatefulWidget {
  final JobOffer jobOffer;

  CandidateJobDetailsScreen({
    this.jobOffer,
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
      double.parse(widget.jobOffer.latitude),
      double.parse(widget.jobOffer.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCandidateAppBar(translate('page.title.job'), context),
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
                widget.jobOffer.position,
                style: TextStyle(fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.jobOffer.company,
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
              GroupTitle(title: translate('group.title.job_information')),
              SizedBox(
                height: 15.0,
              ),
              DetailsRecord(
                label: translate('field.site_supervisor'),
                value: widget.jobOffer.clientContact,
              ),
              DetailsRecord(
                label: translate('field.shift_date'),
                value:
                    DateFormat('dd/MM/yyyy').format(widget.jobOffer.datetime),
              ),
              DetailsRecord(
                label: translate('field.shift_starting_time'),
                value: DateFormat.jm().format(widget.jobOffer.datetime),
              ),
              DetailsRecord(
                label: translate('field.note'),
                value: widget.jobOffer.notes,
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                color: Colors.white,
                child: Text(translate('button.show')),
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
              RaisedButton(
                color: Colors.white,
                child: Text(translate('button.direct_me')),
                onPressed: () async {
                  final availableMaps = await MapLauncher.installedMaps;
                  print(availableMaps);

                  await availableMaps.first.showMarker(
                    coords: Coords(double.parse(widget.jobOffer.latitude),
                        double.parse(widget.jobOffer.longitude)),
                    title: widget.jobOffer.company,
                  );
                },
              ),
              SizedBox(
                height: 350.0,
                width: 20.0,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(widget.jobOffer.latitude),
                      double.parse(widget.jobOffer.longitude),
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
    );
  }
}
