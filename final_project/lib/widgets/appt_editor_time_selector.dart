import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector(
      // this.isAllDay,
      // this.onAllDay,
      this.startDate,
      this.endDate,
      this.onStartDatePicked,
      this.onStartTimePicked,
      this.onEndDatePicked,
      this.onEndTimePicked,
      {super.key});

  // final bool isAllDay;

  // final OnAllDaySwitcCallback onAllDay;

  final DateTime startDate;

  final DateTime endDate;

  final OnTapCallback onStartDatePicked;

  final OnTapCallback onStartTimePicked;

  final OnTapCallback onEndDatePicked;

  final OnTapCallback onEndTimePicked;

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

// typedef OnAllDaySwitcCallback = void Function(bool);
typedef OnTapCallback = void Function();

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ListTile(
        //     contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
        //     leading: Icon(Icons.access_time,
        //         color: Theme.of(context).colorScheme.tertiary),
        //     title: Row(children: <Widget>[
        //       Expanded(
        //         child: Text('All-day',
        //             style: TextStyle(
        //                 fontSize:
        //                     Theme.of(context).textTheme.titleLarge!.fontSize,
        //                 color: Theme.of(context).colorScheme.tertiary)),
        //       ),
        //       Expanded(
        //           child: Align(
        //               alignment: Alignment.centerRight,
        //               child: Switch(
        //                 value: widget.isAllDay,
        //                 onChanged: (bool value) => widget.onAllDay(value),
        //               ))),
        //     ])),
        ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(children: <Widget>[
              Expanded(
                flex: 7,
                child: GestureDetector(
                  onTap: () async => widget.onStartDatePicked(),
                  child: Text(
                      DateFormat('EEE, MMM dd yyyy').format(widget.startDate),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                          color: Theme.of(context).colorScheme.tertiary)),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () async => widget.onStartTimePicked(),
                    child: Text(DateFormat('hh:mm a').format(widget.startDate),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            color: Theme.of(context).colorScheme.tertiary)),
                  )),
            ])),
        ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(children: <Widget>[
              Expanded(
                flex: 7,
                child: GestureDetector(
                  onTap: () async => widget.onEndDatePicked(),
                  child: Text(
                      DateFormat('EEE, MMM dd yyyy').format(widget.endDate),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                          color: Theme.of(context).colorScheme.tertiary)),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () async => widget.onEndTimePicked(),
                    child: Text(DateFormat('hh:mm a').format(widget.endDate),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            color: Theme.of(context).colorScheme.tertiary)),
                  )),
            ])),
        // ListTile(
        //   contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
        //   leading: Icon(Icons.refresh,
        //       color: Theme.of(context).colorScheme.tertiary),
        //   title: Text(
        //       widget.rule == SelectRule.doesNotRepeat
        //           ? 'Does not repeat'
        //           : widget.rule == SelectRule.everyDay
        //               ? 'Every day'
        //               : widget.rule == SelectRule.everyWeek
        //                   ? 'Every week'
        //                   : widget.rule == SelectRule.everyMonth
        //                       ? 'Every month'
        //                       : widget.rule == SelectRule.everyYear
        //                           ? 'Every year'
        //                           : 'Custom',
        //       style: TextStyle(
        //           fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
        //           color: Theme.of(context).colorScheme.tertiary)),
        //   onTap: () async => widget.onSelectRuleTapped(),
        // ),
      ],
    );
  }
}
