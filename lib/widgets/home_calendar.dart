import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/models/carrier_model.dart';
import 'package:piiprent/models/shift_model.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/candidate_work_statistics.dart';
import '../screens/timesheets_details/widgets/date_picker_box_widget.dart';

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

  Map<DateTime, List<Shift>> _clientFulfilledShifts;
  Map<DateTime, List<Shift>> _clientUnfulfilledShifts;

  List<Shift> _shifts;

  int currentIndex = 0;

  bool _isLoading = true;

  CandidateWorkState _candidateWorkStates = CandidateWorkState();

  bool _isCustomCounter = false;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  _initCandidateCalendar() async {
    if (widget.userId == null) {
      return;
    }

    var data = await _candidateService.getStatistics(
        contactId: widget.userId,
        startedAt0: DateTime.now(),
        startedAt1: DateTime.now());
    if (data != null) {
      _candidateWorkStates =
          CandidateWorkState.fromJson(json.decode(data.body));
    }

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
        _isLoading = false;
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
      var data = await _candidateService.getStatistics(
          contactId: widget.userId,
          startedAt0: DateTime.now(),
          startedAt1: DateTime.now());
      if (data != null) {
        _candidateWorkStates =
            CandidateWorkState.fromJson(json.decode(data.body));
      }
      _clientFulfilledShifts = {};
      _clientUnfulfilledShifts = {};

      setState(() {
        shifts.forEach((Shift el) {
          if (el.isFulfilled) {
            _clientFulfilledShifts.addAll({
              el.date: [el]
            });
          } else {
            _clientUnfulfilledShifts.addAll({
              el.date: [el]
            });
          }
        });
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // _calendarController = CalendarController();
    currentIndex = 3;

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

  List<String> counterButtons = [
    'Last month',
    'This Month',
    'This week',
    'Today',
    'This Year',
    'Custom'
  ];

  Widget _buildCandidateCalendar(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 1250,
      ),
      child: Column(
        children: [
          TableCalendar(
            headerStyle:
                HeaderStyle(titleCentered: true, formatButtonVisible: false),
            // calendarFormat: CalendarFormat.month,
            rowHeight: 40,
            //todo: revert to one month later for ruslanzaharov1105@gmail.com, later remove it
            focusedDay: DateTime(DateTime.now().year, DateTime.now().month - 1,
                DateTime.now().day),
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: Jiffy().add(years: 1).dateTime,
            currentDay: DateTime(DateTime.now().year, DateTime.now().month - 1,
                DateTime.now().day),

            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (date, events) {
              String id = _candidateAvailable[date] != null
                  ? _candidateAvailable[date][0].id
                  : _candidateUnavailable[date] != null
                      ? _candidateUnavailable[date][0].id
                      : null;

              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  actions: [
                    ElevatedButton(
                      onPressed: _candidateAvailable[date] == null
                          ? () {
                              Navigator.of(context)
                                  .pop(CarrrierStatus.Available);
                            }
                          : null,
                      child: Text(translate('button.available')),
                    ),
                    ElevatedButton(
                      onPressed: _candidateUnavailable[date] == null
                          ? () {
                              Navigator.of(context)
                                  .pop(CarrrierStatus.Unavailable);
                            }
                          : null,
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
            calendarBuilders: CalendarBuilders(
              outsideBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) =>
                      SizedBox(),
              disabledBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) =>
                      day.month == DateTime.now().month ? null : SizedBox(),
              markerBuilder: (context, date, events) {
                if (_candidateAvailable != null) {
                  if (_candidateAvailable[date] != null) {
                    return Positioned(
                      bottom: 2,
                      child: _buildCircle(
                        radius: 3.0,
                        color: Colors.green[400],
                      ),
                    );
                  }
                }

                if (_candidateUnavailable != null) {
                  if (_candidateUnavailable[date] != null) {
                    return Positioned(
                      bottom: 2,
                      child: _buildCircle(
                        radius: 3.0,
                        color: Colors.red[400],
                      ),
                    );
                  }
                }

                return SizedBox();
              },
            ),
          ),
          _buildCandidateLegend(),
          SizedBox(
            height: 10,
          ),
          Material(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        children: [
                          ...List.generate(counterButtons.length, (index) => CounterButton(
                            index: index,
                            last: counterButtons.length - 1,
                            title: counterButtons[index],
                            onTapped: currentIndex == index,
                            onPressed: () async {
                              setState(() {
                                currentIndex = index;
                                _isLoading = true;
                                _isCustomCounter = false;
                              });
                              if (index == 5) {
                                setState(() {
                                  _isCustomCounter = true;
                                });
                              }
                              if (!_isCustomCounter) {
                                await _calculateEarning(index);
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCustomDate(),
                    SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildReportHeader(),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Hourly',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${_candidateWorkStates.hourlyWork.totalHours}h ${_candidateWorkStates.hourlyWork.totalMinutes}m',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '\$${_candidateWorkStates.hourlyWork.totalEarned}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            calculateTotal(),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReportHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Activity',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Amount',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Earned',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
  Widget calculateTotal() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Shifts: ${_candidateWorkStates.shiftsTotal}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Text(
            'Total:  \$${_candidateWorkStates.hourlyWork.totalEarned}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      );

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: data
            .map(
              (el) => Row(
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
              color: Colors.black,
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
          headerStyle:
          HeaderStyle(titleCentered: true, formatButtonVisible: false),
          //todo: revert to one month later for ruslanzaharov1105@gmail.com, later remove it
          focusedDay: DateTime(DateTime.now().year, DateTime.now().month - 1,
              DateTime.now().day),
          firstDay: DateTime.now().subtract(Duration(days: 365)),
          lastDay: Jiffy().add(years: 1).dateTime,
          currentDay: DateTime(DateTime.now().year, DateTime.now().month - 1,
              DateTime.now().day),
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: (date, events) {
            List<Shift> shifts = [];
            _clientFulfilledShifts.values
                .forEach((shift) => shifts.forEach((element) {
                      shifts.add(element);
                    }));
            _clientUnfulfilledShifts.values
                .forEach((shift) => shifts.forEach((element) {
                      shifts.add(element);
                    }));

            setState(() {
              _shifts = shifts;
            });
          },
          calendarBuilders: CalendarBuilders(
            outsideBuilder:
                (BuildContext context, DateTime day, DateTime focusedDay) =>
                SizedBox(),
            disabledBuilder:
                (BuildContext context, DateTime day, DateTime focusedDay) =>
            day.month == DateTime.now().month ? null : SizedBox(),
            markerBuilder: (context, date, events) {
              if (_clientFulfilledShifts != null) {
                if (_clientFulfilledShifts[date] != null) {
                  return Positioned(
                    bottom: 2,
                    child: _buildCircle(
                      radius: 4.0,
                      color: Colors.green[400],
                    ),
                  );
                }
              }

              if (_clientUnfulfilledShifts != null) {
                if (_clientUnfulfilledShifts[date] != null) {
                  return Positioned(
                    bottom: 2,
                    child: _buildCircle(
                      radius: 4.0,
                      color: Colors.red[400],
                    ),
                  );
                }
              }

              return SizedBox();
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

  _calculateEarning(int index) async {
    DateTime now = DateTime.now();
    //todo: revert to one month later for ruslanzaharov1105@gmail.com
    now = DateTime(now.year,now.month-1,now.day);
    int lastDay = DateTime(now.year, now.month + 1, 0).day;
    DateTime firstDate = DateTime(now.year, now.month - 1, 1);
    DateTime lastDate = DateTime(now.year, now.month - 1, lastDay);
    if (index == 0) {
      lastDay = DateTime(now.year, now.month, 0).day;
      firstDate = DateTime(now.year, now.month - 1, 1);
      lastDate = DateTime(now.year, now.month - 1, lastDay);
    } else if (index == 1) {
      lastDay = DateTime(now.year, now.month + 1, 0).day;
      firstDate = DateTime(now.year, now.month, 1);
      lastDate = DateTime(now.year, now.month, lastDay);
    } else if (index == 2) {
      firstDate = findFirstDateOfTheWeek(now);
      lastDate = findLastDateOfTheWeek(now);
    } else if (index == 3) {
      firstDate = now;
      lastDate = now;
    } else if (index == 4) {
      firstDate = DateTime(now.year, 1, 1);
      lastDate = DateTime(now.year, 12, 31);
    } else {
      firstDate = fromDate;
      lastDate = toDate;
    }

    try {
      var data = await _candidateService.getStatistics(
          contactId: widget.userId,
          startedAt0: firstDate,
          startedAt1: lastDate);
      if (data != null) {
        _candidateWorkStates =
            CandidateWorkState.fromJson(json.decode(data.body));
      }
    } catch (e) {
      print(e);
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  _buildCustomDate() {
    return Visibility(
      visible: _isCustomCounter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.6,
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      DatePickerBoxWidget(
                        horPad: 6,
                        verPad: 9,
                        fontSize: 12,
                        imageHeight: 13,
                        imageWidth: 13,
                        initialDate: fromDate,
                        onDateSelected: (DateTime startDate) {
                          DateTime _dateTime = DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            fromDate?.hour ?? 0,
                            fromDate?.minute ?? 0,
                          );
                          fromDate = _dateTime;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.6,
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      DatePickerBoxWidget(
                        horPad: 6,
                        verPad: 9,
                        fontSize: 12,
                        imageHeight: 13,
                        imageWidth: 13,
                        initialDate: toDate,
                        onDateSelected: (DateTime startDate) {
                          DateTime _dateTime = DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            toDate?.hour ?? 0,
                            toDate?.minute ?? 0,
                          );
                          toDate = _dateTime;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                          _isCustomCounter = false;
                        });
                        await _calculateEarning(5);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            border: Border.all(color: Colors.white)),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CounterButton extends StatefulWidget {
  const CounterButton(
      {Key key,
      this.title,
      this.onPressed,
      this.onTapped,
      this.index,
      this.last})
      : super(key: key);
  final String title;
  final Function() onPressed;
  final bool onTapped;
  final int index;
  final int last;
  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  double radius =3;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        widget.onPressed();
        setState(() {});
      },
      child: Container(
        width: size.width > 650
            ? size.width < 1355
                ? size.width / 6.6
                : size.width / 9.2
            : size.width / 3.6,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        decoration: BoxDecoration(
          color: widget.onTapped ? AppColors.darkBlue : Colors.white,
          // borderRadius: widget.index == widget.last || widget.index == 0
          //     ? BorderRadius.only(
          //         topLeft: widget.index == 0
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //         bottomLeft: widget.index == 0
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //         bottomRight: widget.index == widget.last
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //         topRight: widget.index == widget.last
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //       )
          //     : BorderRadius.circular(1),
          border: Border.all(
            color: widget.onTapped ? AppColors.blueBorder : Colors.black,
            width: 0.3,
          ),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: widget.onTapped ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
