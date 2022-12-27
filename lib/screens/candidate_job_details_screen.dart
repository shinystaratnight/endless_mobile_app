import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';

import '../widgets/size_config.dart';


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
  //GoogleMapController _mapController;
  Completer<GoogleMapController> _mapController = Completer();
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
    _mapController.complete(controller);
    debugPrint(widget.jobOffer.latitude + widget.jobOffer.longitude);
  }

  LocationData _currentPosition;
  String _address;
  Location location = new Location();
  fetchLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      // setState(() {
      //   _currentPosition = currentLocation;
      //   getAddress(_currentPosition.latitude, _currentPosition.longitude)
      //       .then((value) {
      //     setState(() {
      //       _address = "${value.first.addressLine}";
      //     });
      //   });
      // });
    });
  }
  @override
  void initState() {
    super.initState();
    _add(
      double.parse(widget.jobOffer.latitude),
      double.parse(widget.jobOffer.longitude),
    );
    fetchLocation();
  }

  void showConcernDialog(Function allowed) {
    showProminentDisclosureDialog(context, (bool isAllowed) {
      if (isAllowed == true) {
        allowed();
      } else if (isAllowed == false) {
        showDenyAlertDialog(context, (bool isAllowed) {
          if (isAllowed == true) {
            showConcernDialog(allowed);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCandidateAppBar(translate('page.title.job'), context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            //16.0,
            SizeConfig.heightMultiplier * 2.34,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                //height: 25.0,
                height: SizeConfig.heightMultiplier * 3.66,
              ),
              Text(
                widget.jobOffer.position,
                style: TextStyle(
                  //fontSize: 22.0,
                  fontSize: SizeConfig.heightMultiplier * 3.22,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.jobOffer.company,
                style: TextStyle(
                  //fontSize: 18.0,
                  fontSize: SizeConfig.heightMultiplier * 2.64,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                //height: 15.0,
                height: SizeConfig.heightMultiplier * 2.34,
              ),
              // TODO: Add tags
              // GroupTitle(title: 'Tags'),
              GroupTitle(title: translate('group.title.job_information')),
              SizedBox(
                //height: 15.0,
                height: SizeConfig.heightMultiplier * 2.34,
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
                //height: 15.0,
                height: SizeConfig.heightMultiplier * 2.34,
              ),
              // MaterialButton(
              //   color: Colors.white,
              //   child: Text(translate('button.show')),
              //   onPressed: () async {
              //     showConcernDialog(() async {
              //       try {
              //         LocationData data = await _location.getLocation();
              //
              //         _add(data.latitude, data.longitude);
              //         _mapController.animateCamera(
              //           CameraUpdate.newCameraPosition(
              //             CameraPosition(
              //               target: LatLng(data.latitude, data.longitude),
              //             ),
              //           ),
              //         );
              //       } catch (e) {
              //         print(e);
              //       }
              //     });
              //   },
              // ),
              // ShowDirections(),
              MaterialButton(
                color: Colors.white,
                child: Text(
                  translate('button.direct_me'),
                  style: TextStyle(
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                ),
                onPressed: () async {
                  final availableMaps = await MapLauncher.installedMaps;
                  print("availableMaps : $availableMaps");

                  // await availableMaps.first.showMarker(
                  //   coords: Coords(double.parse(widget.jobOffer.latitude),
                  //       double.parse(widget.jobOffer.longitude)),
                  //   title: widget.jobOffer.company,
                  // );
                  for (var map in availableMaps){
                    map.showDirections(
                      destination: Coords(
                        double.parse(widget.jobOffer.latitude),
                        double.parse(widget.jobOffer.longitude),
                      ),
                      destinationTitle: widget.jobOffer.company,
                      origin: Coords(58.369911000000000, 26.783764000000000),
                      // origin: Coords(_currentPosition.latitude, _currentPosition.longitude),
                      // originTitle: originTitle,
                      // waypoints: waypoints,
                      directionsMode: DirectionsMode.driving,
                    );
                  }
                },
              ),
              SizedBox(
                // height: 350.0,
                // width: 20.0,
                height: SizeConfig.heightMultiplier * 51.24,
                width: SizeConfig.widthMultiplier * 4.87,
                child: GoogleMap(
                  cameraTargetBounds: CameraTargetBounds.unbounded,
                  // indoorViewEnabled: true,
                  // zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(widget.jobOffer.latitude),
                      double.parse(widget.jobOffer.longitude),
                    ),
                    zoom: 2,
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

/*

class ShowDirections extends StatefulWidget {
  const ShowDirections({Key key}) : super(key: key);

  @override
  _ShowDirectionsState createState() => _ShowDirectionsState();
}

class _ShowDirectionsState extends State<ShowDirections> {
  double destinationLatitude = 37.759392;
  double destinationLongitude = -122.5107336;
  String destinationTitle = 'Ocean Beach';

  double originLatitude = 37.8078513;
  double originLongitude = -122.404604;
  String originTitle = 'Pier 33';

  // List<Coords> waypoints = [];
  List<Coords> waypoints = [
    Coords(37.7705112, -122.4108267),
    // Coords(37.6988984, -122.4830961),
    // Coords(37.7935754, -122.483654),
  ];

  DirectionsMode directionsMode = DirectionsMode.driving;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            FormTitle('Destination'),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Destination Latitude'),
              initialValue: destinationLatitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  destinationLatitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Destination Longitude'),
              initialValue: destinationLongitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  destinationLongitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Destination Title'),
              initialValue: destinationTitle,
              onChanged: (newValue) {
                setState(() {
                  destinationTitle = newValue;
                });
              },
            ),
            FormTitle('Origin'),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                labelText: 'Origin Latitude (uses current location if empty)',
              ),
              initialValue: originLatitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  originLatitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                labelText: 'Origin Longitude (uses current location if empty)',
              ),
              initialValue: originLongitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  originLongitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Origin Title'),
              initialValue: originTitle,
              onChanged: (newValue) {
                setState(() {
                  originTitle = newValue;
                });
              },
            ),
            WaypointsForm(
              waypoints: waypoints,
              onWaypointsUpdated: (updatedWaypoints) {
                setState(() {
                  waypoints = updatedWaypoints;
                });
              },
            ),
            FormTitle('Directions Mode'),
            Container(
              alignment: Alignment.centerLeft,
              child: DropdownButton(
                value: directionsMode,
                onChanged: (newValue) {
                  setState(() {
                    directionsMode = newValue as DirectionsMode;
                  });
                },
                items: DirectionsMode.values.map((directionsMode) {
                  return DropdownMenuItem(
                    value: directionsMode,
                    child: Text(directionsMode.toString()),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                MapsSheet.show(
                  context: context,
                  onMapTap: (map) {
                    map.showDirections(
                      destination: Coords(
                        destinationLatitude,
                        destinationLongitude,
                      ),
                      destinationTitle: destinationTitle,
                      origin: Coords(originLatitude, originLongitude),
                      originTitle: originTitle,
                      waypoints: waypoints,
                      directionsMode: directionsMode,
                    );
                  },
                );
              },
              child: Text('Show Maps'),
            )
          ],
        ),
      ),
    );
  }
}


class FormTitle extends StatelessWidget {
  final String title;
  final Widget trailing;

  FormTitle(this.title, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            Spacer(),
            if (trailing != null) trailing,
          ],
        ),
      ],
    );
  }
}

class WaypointsForm extends StatelessWidget {
  final List<Coords> waypoints;
  final void Function(List<Coords> waypoints) onWaypointsUpdated;

  WaypointsForm({ this.waypoints,  this.onWaypointsUpdated});

  void updateWaypoint(Coords waypoint, int index) {
    final tempWaypoints = [...waypoints];
    tempWaypoints[index] = waypoint;
    onWaypointsUpdated(tempWaypoints);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...waypoints.map((waypoint) {
          final waypointIndex = waypoints.indexOf(waypoint);
          return [
            FormTitle(
              'Waypoint #${waypointIndex + 1}',
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red[300]),
                onPressed: () {
                  onWaypointsUpdated([...waypoints]..removeAt(waypointIndex));
                },
              ),
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                labelText: 'Waypoint #${waypointIndex + 1} latitude',
              ),
              initialValue: waypoint.latitude.toString(),
              onChanged: (newValue) {
                updateWaypoint(
                  Coords(double.tryParse(newValue) ?? 0, waypoint.longitude),
                  waypointIndex,
                );
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                labelText: 'Waypoint #$waypointIndex longitude',
              ),
              initialValue: waypoint.longitude.toString(),
              onChanged: (newValue) {
                updateWaypoint(
                  Coords(waypoint.latitude, double.tryParse(newValue) ?? 0),
                  waypointIndex,
                );
              },
            ),
          ];
        }).expand((element) => element),
        SizedBox(height: 20),
        Row(children: [
          MaterialButton(
            child: Text(
              'Add Waypoint',
              style: TextStyle(
                // color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              onWaypointsUpdated([...waypoints]..add(Coords(0, 0)));
            },
          ),
        ]),
      ],
    );
  }
}

class MapsSheet {
  static show({
     BuildContext context,
     Function(AvailableMap map) onMapTap,
  }) async {
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Wrap(
                      children: <Widget>[
                        for (var map in availableMaps)
                          ListTile(
                            onTap: () => onMapTap(map),
                            title: Text(map.mapName),
                            leading: SvgPicture.asset(
                              map.icon,
                              height: 30.0,
                              width: 30.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}*/
