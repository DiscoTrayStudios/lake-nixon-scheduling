import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';

import 'package:final_project/objects/globals.dart';

class CustomRule extends StatefulWidget {
  const CustomRule(this.selectedAppointment, this.appointmentColor, this.events,
      this.recurrenceProperties,
      {super.key});

  final Appointment selectedAppointment;

  final Color appointmentColor;

  final CalendarDataSource events;

  final RecurrenceProperties? recurrenceProperties;

  @override
  CustomRuleState createState() => CustomRuleState();
}

class CustomRuleState extends State<CustomRule> {
  late DateTime _startDate;
  // EndRule? _endRule;
  RecurrenceProperties? _recurrenceProperties;
  String? _selectedRecurrenceType, _monthlyRule, _weekNumberDay;
  int? _count, _interval, _month, _week;
  late int _dayOfWeek, _weekNumber, _dayOfMonth;
  late DateTime _selectedDate, _firstDate;
  late RecurrenceType _recurrenceType;
  late RecurrenceRange _recurrenceRange;
  List<WeekDays>? _days;
  late double _width;
  bool _isLastDay = false;

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  void _updateAppointmentProperties() {
    _width = 180;
    _startDate = widget.selectedAppointment.startTime;
    _selectedDate = _startDate.add(const Duration(days: 30));
    _count = 1;
    _interval = 1;
    _selectedRecurrenceType = _selectedRecurrenceType ?? 'day';
    _dayOfMonth = _startDate.day;
    _dayOfWeek = _startDate.weekday;
    _monthlyRule = 'Monthly on day ${_startDate.day}th';
    // _endRule = EndRule.never;
    _month = _startDate.month;
    _weekNumber = _getWeekNumber(_startDate);
    _weekNumberDay =
        '${weekDayPosition[_weekNumber == -1 ? 4 : _weekNumber - 1]} ${weekDay[_dayOfWeek - 1]}';
    if (_days == null) {
      _mobileInitialWeekdays(_startDate.weekday);
    }
    final Appointment? parentAppointment = widget.events
        .getPatternAppointment(widget.selectedAppointment, '') as Appointment?;
    if (parentAppointment == null) {
      _firstDate = _startDate;
    } else {
      _firstDate = parentAppointment.startTime;
    }
    _recurrenceProperties = widget.selectedAppointment.recurrenceRule != null &&
            widget.selectedAppointment.recurrenceRule!.isNotEmpty
        ? SfCalendar.parseRRule(
            widget.selectedAppointment.recurrenceRule!, _firstDate)
        : null;
    _recurrenceProperties == null
        ? _recurrenceProperties = RecurrenceProperties(startDate: _firstDate)
        : _updateCustomRecurrenceProperties();
  }

  void _updateCustomRecurrenceProperties() {
    _recurrenceType = _recurrenceProperties!.recurrenceType;
    _week = _recurrenceProperties!.week;
    _weekNumber = _recurrenceProperties!.week == 0
        ? _weekNumber
        : _recurrenceProperties!.week;
    _month = _recurrenceProperties!.month;
    _dayOfMonth = _recurrenceProperties!.dayOfMonth == 1
        ? _startDate.day
        : _recurrenceProperties!.dayOfMonth;
    _dayOfWeek = _recurrenceProperties!.dayOfWeek;

    switch (_recurrenceType) {
      case RecurrenceType.daily:
        _dayRule();
        break;
      case RecurrenceType.weekly:
        _days = _recurrenceProperties!.weekDays;
        _weekRule();
        break;
      case RecurrenceType.monthly:
        _monthRule();
        break;
      case RecurrenceType.yearly:
        _month = _recurrenceProperties!.month;
        _yearRule();
        break;
    }
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    switch (_recurrenceRange) {
      case RecurrenceRange.noEndDate:
        // _endRule = EndRule.never;
        _rangeNoEndDate();
        break;
      case RecurrenceRange.endDate:
        // _endRule = EndRule.endDate;
        final Appointment? parentAppointment =
            widget.events.getPatternAppointment(widget.selectedAppointment, '')
                as Appointment?;
        _firstDate = parentAppointment!.startTime;
        _rangeEndDate();
        break;
      case RecurrenceRange.count:
        // _endRule = EndRule.count;
        _rangeCount();
        break;
    }
  }

  void _dayRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.daily;
      _selectedRecurrenceType = 'day';
    });
  }

  void _weekRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.weekly;
      _selectedRecurrenceType = 'week';
      _recurrenceProperties!.weekDays = _days!;
    });
  }

  void _monthRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _monthlyDay();
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
        _week == 0 || _week == null ? _monthlyDay() : _monthlyWeek();
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.monthly;
      _selectedRecurrenceType = 'month';
    });
  }

  void _yearRule() {
    setState(() {
      if (_recurrenceProperties == null) {
        _recurrenceProperties = RecurrenceProperties(startDate: _startDate);
        _monthlyDay();
        _interval = 1;
      } else {
        _interval = _recurrenceProperties!.interval;
        _week == 0 || _week == null ? _monthlyDay() : _monthlyWeek();
      }
      _recurrenceProperties!.recurrenceType = RecurrenceType.yearly;
      _selectedRecurrenceType = 'year';
      _recurrenceProperties!.month = _month!;
    });
  }

  void _rangeNoEndDate() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
  }

  void _rangeEndDate() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.endDate;
    _selectedDate = _recurrenceProperties!.endDate ??
        _startDate.add(const Duration(days: 30));
    _recurrenceProperties!.endDate = _selectedDate;
  }

  void _rangeCount() {
    _recurrenceProperties!.recurrenceRange = RecurrenceRange.count;
    _count = _recurrenceProperties!.recurrenceCount == 0
        ? 1
        : _recurrenceProperties!.recurrenceCount;
    _recurrenceProperties!.recurrenceCount = _count!;
  }

  void _monthlyWeek() {
    setState(() {
      _monthlyRule = 'Monthly on the ${_weekNumberDay!}';
      _recurrenceProperties!.week = _weekNumber;
      _recurrenceProperties!.dayOfWeek = _dayOfWeek;
    });
  }

  void _monthlyDay() {
    setState(() {
      _monthlyRule = 'Monthly on day ${_startDate.day}th';
      _recurrenceProperties!.dayOfWeek = 0;
      _recurrenceProperties!.week = 0;
      _recurrenceProperties!.dayOfMonth = _dayOfMonth;
    });
  }

  void _lastDayOfMonth() {
    setState(() {
      _monthlyRule = 'Last day of month';
      _recurrenceProperties!.dayOfWeek = 0;
      _recurrenceProperties!.week = 0;
      _recurrenceProperties!.dayOfMonth = -1;
    });
  }

  int _getWeekNumber(DateTime startDate) {
    int weekOfMonth;
    weekOfMonth = (startDate.day / 7).ceil();
    if (weekOfMonth == 5) {
      return -1;
    }
    return weekOfMonth;
  }

  void _mobileSelectWeekDays(WeekDays day) {
    switch (day) {
      case WeekDays.sunday:
        if (_days!.contains(WeekDays.sunday) && _days!.length > 1) {
          _days!.remove(WeekDays.sunday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.sunday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.monday:
        if (_days!.contains(WeekDays.monday) && _days!.length > 1) {
          _days!.remove(WeekDays.monday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.monday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.tuesday:
        if (_days!.contains(WeekDays.tuesday) && _days!.length > 1) {
          _days!.remove(WeekDays.tuesday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.tuesday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.wednesday:
        if (_days!.contains(WeekDays.wednesday) && _days!.length > 1) {
          _days!.remove(WeekDays.wednesday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.wednesday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.thursday:
        if (_days!.contains(WeekDays.thursday) && _days!.length > 1) {
          _days!.remove(WeekDays.thursday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.thursday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.friday:
        if (_days!.contains(WeekDays.friday) && _days!.length > 1) {
          _days!.remove(WeekDays.friday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.friday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
      case WeekDays.saturday:
        if (_days!.contains(WeekDays.saturday) && _days!.length > 1) {
          _days!.remove(WeekDays.saturday);
          _recurrenceProperties!.weekDays = _days!;
        } else {
          _days!.add(WeekDays.saturday);
          _recurrenceProperties!.weekDays = _days!;
        }
        break;
    }
  }

  void _mobileInitialWeekdays(int day) {
    switch (_startDate.weekday) {
      case DateTime.monday:
        _days = <WeekDays>[WeekDays.monday];
        break;
      case DateTime.tuesday:
        _days = <WeekDays>[WeekDays.tuesday];
        break;
      case DateTime.wednesday:
        _days = <WeekDays>[WeekDays.wednesday];
        break;
      case DateTime.thursday:
        _days = <WeekDays>[WeekDays.thursday];
        break;
      case DateTime.friday:
        _days = <WeekDays>[WeekDays.friday];
        break;
      case DateTime.saturday:
        _days = <WeekDays>[WeekDays.saturday];
        break;
      case DateTime.sunday:
        _days = <WeekDays>[WeekDays.sunday];
        break;
    }
  }

  double _textSize(String text) {
    const TextStyle textStyle =
        TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout();
    return textPainter.width + 60;
  }

  Widget _getCustomRule(BuildContext context) {
    return Container(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15, bottom: 15),
          child: Text('REPEATS EVERY'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15),
          child: Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 60,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: TextField(
                  controller: TextEditingController.fromValue(TextEditingValue(
                      text: _interval.toString(),
                      selection: TextSelection.collapsed(
                          offset: _interval.toString().length))),
                  cursorColor: const Color(0xff4169e1),
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      _interval = int.parse(value);
                      if (_interval == 0) {
                        _interval = 1;
                      } else if (_interval! >= 999) {
                        setState(() {
                          _interval = 999;
                        });
                      }
                    } else if (value.isEmpty) {
                      _interval = 1;
                    }
                    _recurrenceProperties!.interval = _interval!;
                  },
                  keyboardType: TextInputType.number,
                  // ignore: always_specify_types
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              Container(
                width: 20,
              ),
              Container(
                height: 40,
                width: 100,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: DropdownButton<String>(
                    focusColor: Colors.transparent,
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w400),
                    value: _selectedRecurrenceType,
                    items: mobileRecurrence.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        if (value == 'day') {
                          _selectedRecurrenceType = 'day';
                          _dayRule();
                        } else if (value == 'week') {
                          _selectedRecurrenceType = 'week';
                          _weekRule();
                        } else if (value == 'month') {
                          _selectedRecurrenceType = 'month';
                          _monthRule();
                        } else if (value == 'year') {
                          _selectedRecurrenceType = 'year';
                          _yearRule();
                        }
                      });
                    }),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
        ),
        Visibility(
            visible: _selectedRecurrenceType == 'week',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: Text('REPEATS ON'),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 15, top: 5),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mobileSelectWeekDays(WeekDays.sunday);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(5, 5),
                            backgroundColor: _days!.contains(WeekDays.sunday)
                                ? const Color(0xff4169e1)
                                : Theme.of(context).colorScheme.tertiary,
                            foregroundColor: _days!.contains(WeekDays.sunday)
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Text('S'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mobileSelectWeekDays(WeekDays.monday);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(7, 7),
                            disabledForegroundColor: Colors.black26,
                            disabledBackgroundColor: Colors.black26,
                            backgroundColor: _days!.contains(WeekDays.monday)
                                ? const Color(0xff4169e1)
                                : Theme.of(context).colorScheme.tertiary,
                            foregroundColor: _days!.contains(WeekDays.monday)
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          child: const Text('M'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mobileSelectWeekDays(WeekDays.tuesday);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(7, 7),
                            disabledForegroundColor: Colors.black26,
                            disabledBackgroundColor: Colors.black26,
                            backgroundColor: _days!.contains(WeekDays.tuesday)
                                ? const Color(0xff4169e1)
                                : Theme.of(context).colorScheme.tertiary,
                            foregroundColor: _days!.contains(WeekDays.tuesday)
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Text('T'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mobileSelectWeekDays(WeekDays.wednesday);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(7, 7),
                            disabledForegroundColor: Colors.black26,
                            disabledBackgroundColor: Colors.black26,
                            backgroundColor: _days!.contains(WeekDays.wednesday)
                                ? const Color(0xff4169e1)
                                : Theme.of(context).colorScheme.tertiary,
                            foregroundColor: _days!.contains(WeekDays.wednesday)
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          child: const Text('W'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mobileSelectWeekDays(WeekDays.thursday);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(7, 7),
                            disabledForegroundColor: Colors.black26,
                            disabledBackgroundColor: Colors.black26,
                            backgroundColor: _days!.contains(WeekDays.thursday)
                                ? const Color(0xff4169e1)
                                : Theme.of(context).colorScheme.tertiary,
                            foregroundColor: _days!.contains(WeekDays.thursday)
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Text('T'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mobileSelectWeekDays(WeekDays.friday);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(7, 7),
                            disabledForegroundColor: Colors.black26,
                            disabledBackgroundColor: Colors.black26,
                            backgroundColor: _days!.contains(WeekDays.friday)
                                ? const Color(0xff4169e1)
                                : Theme.of(context).colorScheme.tertiary,
                            foregroundColor: _days!.contains(WeekDays.friday)
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Text('F'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mobileSelectWeekDays(WeekDays.saturday);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(7, 7),
                            disabledForegroundColor: Colors.black26,
                            disabledBackgroundColor: Colors.black26,
                            backgroundColor: _days!.contains(WeekDays.saturday)
                                ? const Color(0xff4169e1)
                                : Theme.of(context).colorScheme.tertiary,
                            foregroundColor: _days!.contains(WeekDays.saturday)
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Text('S'),
                        ),
                      ],
                    )),
                const Divider(
                  thickness: 1,
                ),
              ],
            )),
        Visibility(
          visible: _selectedRecurrenceType == 'month',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 40,
                width: _width,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.all(15),
                child: DropdownButton<String>(
                    focusColor: Colors.transparent,
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w400),
                    value: _monthlyRule,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: 'Monthly on day ${_startDate.day}th',
                        child: Text('Monthly on day ${_startDate.day}th'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Monthly on the ${_weekNumberDay!}',
                        child: Text('Monthly on the ${_weekNumberDay!}'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'Last day of month',
                        child: Text('Last day of month'),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        if (value == 'Monthly on day ${_startDate.day}th') {
                          _width =
                              _textSize('Monthly on day ${_startDate.day}th');
                          _monthlyDay();
                        } else if (value ==
                            'Monthly on the ${_weekNumberDay!}') {
                          _width =
                              _textSize('Monthly on the ${_weekNumberDay!}');
                          _monthlyWeek();
                        } else if (value == 'Last day of month') {
                          _width = _textSize('Last day of month');
                          _lastDayOfMonth();
                        }
                      });
                    }),
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
        Visibility(
          visible: _selectedRecurrenceType == 'year',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Checkbox(
                focusColor: const Color(0xff4169e1),
                activeColor: const Color(0xff4169e1),
                value: _isLastDay,
                onChanged: (bool? value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _isLastDay = value;
                    _lastDayOfMonth();
                  });
                },
              ),
              const Text(
                'Last day of month',
              ),
            ],
          ),
        ),
        if (_selectedRecurrenceType == 'year')
          const Divider(
            thickness: 1,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text('ENDS'),
            ),
            // RadioListTile<EndRule>(
            //   contentPadding: const EdgeInsets.only(left: 7),
            //   title: const Text('Never'),
            //   value: EndRule.never,
            //   groupValue: _endRule,
            //   activeColor: const Color(0xff4169e1),
            //   onChanged: (EndRule? value) {
            //     setState(() {
            //       _endRule = EndRule.never;
            //       _rangeNoEndDate();
            //     });
            //   },
            // ),
            const Divider(
              indent: 50,
              height: 1.0,
              thickness: 1,
            ),
            // RadioListTile<EndRule>(
            //   contentPadding: const EdgeInsets.only(left: 7),
            //   title: Row(
            //     children: <Widget>[
            //       const Text('On'),
            //       Container(
            //         margin: const EdgeInsets.only(left: 5),
            //         width: 110,
            //         height: 40,
            //         decoration: BoxDecoration(
            //           color: Colors.grey.withOpacity(0.1),
            //           borderRadius: BorderRadius.circular(3),
            //         ),
            //         child: ButtonTheme(
            //             minWidth: 30.0,
            //             child: MaterialButton(
            //                 elevation: 0,
            //                 focusElevation: 0,
            //                 highlightElevation: 0,
            //                 disabledElevation: 0,
            //                 hoverElevation: 0,
            //                 onPressed: () async {
            //                   final DateTime? pickedDate =
            //                       await showDatePicker(
            //                           context: context,
            //                           initialDate: _selectedDate,
            //                           firstDate:
            //                               _startDate.isBefore(_firstDate)
            //                                   ? _startDate
            //                                   : _firstDate,
            //                           currentDate: _selectedDate,
            //                           lastDate: DateTime(2050),
            //                           builder: (BuildContext context,
            //                               Widget? child) {
            //                             return Theme(
            //                               data: ThemeData(
            //                                 brightness: Brightness.light,
            //                                 colorScheme:
            //                                     ColorScheme.fromSwatch(
            //                                   backgroundColor:
            //                                       const Color(0xff4169e1),
            //                                 ),
            //                               ),
            //                               child: child!,
            //                             );
            //                           });
            //                   if (pickedDate == null) {
            //                     return;
            //                   }
            //                   setState(() {
            //                     _endRule = EndRule.endDate;
            //                     _recurrenceProperties!.recurrenceRange =
            //                         RecurrenceRange.endDate;
            //                     _selectedDate = DateTime(pickedDate.year,
            //                         pickedDate.month, pickedDate.day);
            //                     _recurrenceProperties!.endDate =
            //                         _selectedDate;
            //                   });
            //                 },
            //                 shape: const CircleBorder(),
            //                 child: Text(
            //                   DateFormat('MM/dd/yyyy')
            //                       .format(_selectedDate),
            //                   style: const TextStyle(
            //                       fontSize: 13,
            //                       color: defaultTextColor,
            //                       fontWeight: FontWeight.w400),
            //                 ))),
            //       ),
            //     ],
            //   ),
            //   value: EndRule.endDate,
            //   groupValue: _endRule,
            //   activeColor: const Color(0xff4169e1),
            //   onChanged: (EndRule? value) {
            //     setState(() {
            //       _endRule = value;
            //       _rangeEndDate();
            //     });
            //   },
            // ),
            const Divider(
              indent: 50,
              height: 1.0,
              thickness: 1,
            ),
            // SizedBox(
            //   height: 40,
            //   child: RadioListTile<EndRule>(
            //     contentPadding: const EdgeInsets.only(left: 7),
            //     title: Row(
            //       children: <Widget>[
            //         const Text('After'),
            //         Container(
            //           height: 40,
            //           width: 60,
            //           padding: const EdgeInsets.only(left: 5, bottom: 10),
            //           margin: const EdgeInsets.only(left: 5),
            //           alignment: Alignment.topCenter,
            //           decoration: BoxDecoration(
            //             color: Colors.grey.withOpacity(0.1),
            //             borderRadius: BorderRadius.circular(3),
            //           ),
            //           child: TextField(
            //             readOnly: _endRule != EndRule.count,
            //             controller: TextEditingController.fromValue(
            //                 TextEditingValue(
            //                     text: _count.toString(),
            //                     selection: TextSelection.collapsed(
            //                         offset: _count.toString().length))),
            //             cursorColor: const Color(0xff4169e1),
            //             onTap: () {
            //               setState(() {
            //                 _endRule = EndRule.count;
            //               });
            //             },
            //             onChanged: (String value) async {
            //               if (value.isNotEmpty) {
            //                 _count = int.parse(value);
            //                 if (_count == 0) {
            //                   _count = 1;
            //                 } else if (_count! >= 999) {
            //                   setState(() {
            //                     _count = 999;
            //                   });
            //                 }
            //               } else if (value.isEmpty) {
            //                 _count = 1;
            //               }
            //               _endRule = EndRule.count;
            //               _recurrenceProperties!.recurrenceRange =
            //                   RecurrenceRange.count;
            //               _recurrenceProperties!.recurrenceCount = _count!;
            //             },
            //             keyboardType: TextInputType.number,
            //             // ignore: always_specify_types
            //             inputFormatters: [
            //               FilteringTextInputFormatter.digitsOnly
            //             ],
            //             style: const TextStyle(
            //                 fontSize: 13,
            //                 color: defaultTextColor,
            //                 fontWeight: FontWeight.w400),
            //             textAlign: TextAlign.center,
            //             decoration:
            //                 const InputDecoration(border: InputBorder.none),
            //           ),
            //         ),
            //         Container(
            //           width: 10,
            //         ),
            //         const Text('occurrence'),
            //       ],
            //     ),
            //     value: EndRule.count,
            //     groupValue: _endRule,
            //     activeColor: const Color(0xff4169e1),
            //     onChanged: (EndRule? value) {
            //       setState(() {
            //         _endRule = value;
            //         _recurrenceProperties!.recurrenceRange =
            //             RecurrenceRange.count;
            //         _recurrenceProperties!.recurrenceCount = _count!;
            //       });
            //     },
            //   ),
            // ),
          ],
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Recurrence'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context, widget.recurrenceProperties);
          },
        ),
        actions: <Widget>[
          IconButton(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              icon: const Icon(
                Icons.done,
              ),
              onPressed: () {
                Navigator.pop(context, _recurrenceProperties);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Stack(
          children: <Widget>[_getCustomRule(context)],
        ),
      ),
    );
  }
}

bool _canAddRecurrenceAppointment(
    List<DateTime> visibleDates,
    CalendarDataSource dataSource,
    Appointment occurrenceAppointment,
    DateTime startTime) {
  final Appointment parentAppointment = dataSource.getPatternAppointment(
      occurrenceAppointment, '')! as Appointment;
  final List<DateTime> recurrenceDates =
      SfCalendar.getRecurrenceDateTimeCollection(
          parentAppointment.recurrenceRule ?? '', parentAppointment.startTime,
          specificStartDate: visibleDates[0],
          specificEndDate: visibleDates[visibleDates.length - 1]);

  for (int i = 0; i < dataSource.appointments!.length; i++) {
    final Appointment calendarApp = dataSource.appointments![i] as Appointment;
    if (calendarApp.recurrenceId != null &&
        calendarApp.recurrenceId == parentAppointment.id) {
      recurrenceDates.add(calendarApp.startTime);
    }
  }

  if (parentAppointment.recurrenceExceptionDates != null) {
    for (int i = 0;
        i < parentAppointment.recurrenceExceptionDates!.length;
        i++) {
      recurrenceDates.remove(parentAppointment.recurrenceExceptionDates![i]);
    }
  }

  recurrenceDates.sort();
  bool canAddRecurrence =
      isSameDate(occurrenceAppointment.startTime, startTime);
  if (!_isDateInDateCollection(recurrenceDates, startTime)) {
    final int currentRecurrenceIndex =
        recurrenceDates.indexOf(occurrenceAppointment.startTime);
    if (currentRecurrenceIndex == 0 ||
        currentRecurrenceIndex == recurrenceDates.length - 1) {
      canAddRecurrence = true;
    } else if (currentRecurrenceIndex < 0) {
      canAddRecurrence = false;
    } else {
      final DateTime previousRecurrence =
          recurrenceDates[currentRecurrenceIndex - 1];
      final DateTime nextRecurrence =
          recurrenceDates[currentRecurrenceIndex + 1];
      canAddRecurrence = (isDateWithInDateRange(
                  previousRecurrence, nextRecurrence, startTime) &&
              !isSameDate(previousRecurrence, startTime) &&
              !isSameDate(nextRecurrence, startTime)) ||
          canAddRecurrence;
    }
  }

  return canAddRecurrence;
}

bool _isDateInDateCollection(List<DateTime>? dates, DateTime date) {
  if (dates == null || dates.isEmpty) {
    return false;
  }

  for (final DateTime currentDate in dates) {
    if (isSameDate(currentDate, date)) {
      return true;
    }
  }

  return false;
}
