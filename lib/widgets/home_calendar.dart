import 'package:flutter/material.dart';
import 'package:piiprent/models/carrier_model.dart';
import 'package:piiprent/models/shift_model.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
  final String role;

  HomeCalendar({
    @required this.type,
    this.userId,
    this.role,
  });

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  CandidateService _candidateService = CandidateService();
  JobService _jobService = JobService();
  var _calendarController;

  Map<DateTime, List> _candidateUnavailable;
  Map<DateTime, List> _candidateAvailable;

  Map<DateTime, List> _clientFulfilledShifts;
  Map<DateTime, List> _clientUnfulfilledShifts;

  List<Shift> _shifts;

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

  _initClientCalendar() async {
    try {
      List<Shift> shifts = await _jobService.getClientShifts({
        'role': widget.role,
      });

      _clientFulfilledShifts = {};
      _clientUnfulfilledShifts = {};

      setState(() {
        shifts.forEach((Shift el) {
          if (el.isFulfilled) {
            _clientFulfilledShifts.addAll({
              el.datetime: [el]
            });
          } else {
            _clientUnfulfilledShifts.addAll({
              el.datetime: [el]
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

    if (widget.type == CalendarType.Client) {
      _initClientCalendar();
      _shifts = [];
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
                    child: Text(translate('button.available')),
                  ),
                  RaisedButton(
                    onPressed: holidays.length == 0
                        ? () {
                            Navigator.of(context)
                                .pop(CarrrierStatus.Unavailable);
                          }
                        : null,
                    color: Colors.blueAccent,
                    child: Text(translate('button.unavailable')),
                  ),
                ],
                title: Text(id != null
                    ? translate('dialog.update')
                    : translate('dialog.confirm')),
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
                    child: _buildCircle(
                      radius: 4.0,
                      color: Colors.green[400],
                    ),
                  ),
                );
              }

              if (holidays.isNotEmpty) {
                children.add(
                  Positioned(
                    bottom: 2,
                    child: _buildCircle(
                      radius: 4.0,
                      color: Colors.red[400],
                    ),
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

  Widget _buildClientLegend() {
    var data = [
      {
        'color': Colors.green[400],
        'label': translate('group.title.fulfilled'),
      },
      {
        'color': Colors.red[400],
        'label': translate('group.title.unfulfilled'),
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
                      translate(el['label']),
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

  Widget _buildCandidateLegend() {
    var data = [
      {
        'color': Colors.green[400],
        'label': 'button.available',
      },
      {
        'color': Colors.red[400],
        'label': 'button.unavailable',
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
                      translate(el['label']),
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

  Widget _buildTableCell(String text, [Color color = Colors.black]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 16.0),
      ),
    );
  }

  Widget _buildTable(List<Shift> data) {
    if (data.length == 0) {
      return SizedBox();
    }

    List<Shift> body = [];
    body.add(data[0]);
    data.forEach((shift) => body.add(shift));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          margin: const EdgeInsets.only(top: 14.0),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            translate('table.shifts'),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colors.grey,
            ),
          ),
          children: body.asMap().entries.map((e) {
            int i = e.key;
            Shift shift = e.value;

            if (i == 0) {
              return TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: [
                  _buildTableCell(translate('field.jobsite')),
                  _buildTableCell(translate('field.start_time')),
                  _buildTableCell(translate('table.workers')),
                  _buildTableCell(translate('timesheet.status')),
                ],
              );
            }

            return TableRow(
              children: [
                _buildTableCell(shift.jobsite),
                _buildTableCell(DateFormat.jm().format(shift.datetime)),
                _buildTableCell(shift.workers.toString()),
                _buildTableCell(
                  shift.isFulfilled
                      ? translate('group.title.fulfilled')
                      : translate('group.title.unfulfilled'),
                  shift.isFulfilled ? Colors.green[400] : Colors.red[400],
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClientCalendar(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarController: _calendarController,
          events: _clientFulfilledShifts,
          holidays: _clientUnfulfilledShifts,
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: (date, List<dynamic> events, List<dynamic> holidays) {
            List<Shift> shifts = [];
            events.forEach((shift) => shifts.add(shift));
            holidays.forEach((shift) => shifts.add(shift));

            setState(() {
              _shifts = shifts;
            });
          },
          builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];

              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                    bottom: 2,
                    right: 14,
                    child: _buildCircle(
                      radius: 4.0,
                      color: Colors.green[400],
                    ),
                  ),
                );
              }

              if (holidays.isNotEmpty) {
                children.add(
                  Positioned(
                    bottom: 2,
                    left: 14,
                    child: _buildCircle(
                      radius: 4.0,
                      color: Colors.red[400],
                    ),
                  ),
                );
              }

              return children;
            },
          ),
        ),
        _buildTable(_shifts),
        _buildClientLegend(),
      ],
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
