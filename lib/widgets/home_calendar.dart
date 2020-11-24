import 'package:flutter/material.dart';
import 'package:piiprent/models/carrier_model.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:table_calendar/table_calendar.dart';

enum CalendarType {
  Canddate,
  Client,
}

enum CarrrierStatus {
  Available,
  Unavailable,
}

class HomeCalendar extends StatefulWidget {
  final CalendarType type;
  final String userId;

  HomeCalendar({
    @required this.type,
    this.userId,
  });

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  CandidateService _candidateService = CandidateService();
  var _calendarController;

  Map<DateTime, List> _candidateUnavailable;
  Map<DateTime, List> _candidateAvailable;

  _initCandidateCalendar() async {
    try {
      List<Carrier> carriers =
          await _candidateService.getCandidateAvailability(widget.userId);

      _candidateAvailable = {};
      _candidateUnavailable = {};

      setState(() {
        carriers.forEach((Carrier el) {
          if (el.confirmedAvailable) {
            _candidateAvailable.addAll({
              el.targetDateUtc: [el]
            });
          } else {
            _candidateUnavailable.addAll({
              el.targetDateUtc: [el]
            });
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    if (widget.type == CalendarType.Canddate) {
      _initCandidateCalendar();
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  _updateAvailability(
    DateTime date,
    CarrrierStatus status,
    String id,
  ) async {
    if (status.runtimeType != CarrrierStatus) {
      return;
    }

    if (id == null) {
      try {
        Carrier carrier = await _candidateService.setAvailability(
            date, status == CarrrierStatus.Available, widget.userId);

        if (carrier != null) {
          setState(() {
            if (status == CarrrierStatus.Available) {
              _candidateAvailable[date] = [carrier];
            } else {
              _candidateUnavailable[date] = [carrier];
            }
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        Carrier carrier = await _candidateService.updateAvailability(
          date,
          status == CarrrierStatus.Available,
          widget.userId,
          id,
        );

        if (carrier != null) {
          setState(() {
            if (status == CarrrierStatus.Available) {
              _candidateAvailable[date] = [carrier];
              _candidateUnavailable.removeWhere(
                  (key, value) => key.toString() == date.toString());
            } else {
              _candidateAvailable.removeWhere(
                  (key, value) => key.toString() == date.toString());
              _candidateUnavailable[date] = [carrier];
            }
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Widget _buildCandidateCalendar(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarController: _calendarController,
          events: _candidateAvailable,
          holidays: _candidateUnavailable,
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: (date, events, holidays) {
            String id = events.length > 0
                ? events[0].id
                : holidays.length > 0
                    ? holidays[0].id
                    : null;

            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                actions: [
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: events.length == 0
                        ? () {
                            Navigator.of(context).pop(CarrrierStatus.Available);
                          }
                        : null,
                    child: Text('Available'),
                  ),
                  RaisedButton(
                    onPressed: holidays.length == 0
                        ? () {
                            Navigator.of(context)
                                .pop(CarrrierStatus.Unavailable);
                          }
                        : null,
                    color: Colors.blueAccent,
                    child: Text('Unavailable'),
                  ),
                ],
                title: Text(id != null ? 'Update' : 'Confirm?'),
                contentPadding: const EdgeInsets.all(8.0),
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
              ),
            ).then((available) => _updateAvailability(date, available, id));
          },
          builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];

              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                    bottom: 2,
                    child: _buildCircle(radius: 4.0, color: Colors.green[400]),
                  ),
                );
              }

              if (holidays.isNotEmpty) {
                children.add(
                  Positioned(
                    bottom: 2,
                    child: _buildCircle(radius: 4.0, color: Colors.red[400]),
                  ),
                );
              }

              return children;
            },
          ),
        ),
        _buildCandidateLegend(),
      ],
    );
  }

  Widget _buildCandidateLegend() {
    var data = [
      {
        'color': Colors.green[400],
        'label': 'Available',
      },
      {
        'color': Colors.red[400],
        'label': 'Unavailable',
      }
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: data
            .map(
              (el) => Expanded(
                child: Row(
                  children: [
                    _buildCircle(radius: 8.0, color: el['color']),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      el['label'],
                      style: TextStyle(fontSize: 16.0),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCircle({double radius, Color color}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
    );
  }

  Widget _buildClientCalendar(BuildContext context) {
    return TableCalendar(
      calendarController: _calendarController,
      onDaySelected: (date, events, holidays) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == CalendarType.Canddate) {
      return _buildCandidateCalendar(context);
    }

    if (widget.type == CalendarType.Client) {
      return _buildClientCalendar(context);
    }

    return Container(width: 0.0, height: 0.0);
  }
}
