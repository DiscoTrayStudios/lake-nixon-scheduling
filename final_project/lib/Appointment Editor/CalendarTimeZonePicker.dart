import 'package:flutter/material.dart';

import 'AppointmentEditor.dart';

class CalendarTimeZonePicker extends StatefulWidget {
  const CalendarTimeZonePicker(
      this.backgroundColor, this.timeZoneCollection, this.selectedTimeZoneIndex,
      {required this.onChanged});

  final Color backgroundColor;

  final List<String> timeZoneCollection;

  final int selectedTimeZoneIndex;

  final PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() {
    return CalendarTimeZonePickerState();
  }
}

class CalendarTimeZonePickerState extends State<CalendarTimeZonePicker> {
  int _selectedTimeZoneIndex = -1;

  @override
  void initState() {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(CalendarTimeZonePicker oldWidget) {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: theme,
          ),
        ),
        child: AlertDialog(
          content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.timeZoneCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 50,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        leading: Icon(
                          index == _selectedTimeZoneIndex
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: widget.backgroundColor,
                        ),
                        title: Text(widget.timeZoneCollection[index]),
                        onTap: () {
                          setState(() {
                            _selectedTimeZoneIndex = index;
                            widget
                                .onChanged(PickerChangedDetails(index: index));
                          });

                          // ignore: always_specify_types
                          Future.delayed(const Duration(milliseconds: 200), () {
                            // When task is over, close the dialog
                            Navigator.pop(context);
                          });
                        },
                      ));
                },
              )),
        ));
  }
}

typedef PickerChanged = void Function(
    PickerChangedDetails pickerChangedDetails);

/// Details for the [_PickerChanged].
class PickerChangedDetails {
  PickerChangedDetails(
      {this.index = 1,
      this.resourceId,
      this.selectedRule = SelectRule.doesNotRepeat});

  final int index;

  final Object? resourceId;

  final SelectRule? selectedRule;
}

enum SelectRule {
  doesNotRepeat,
  everyDay,
  everyWeek,
  everyMonth,
  everyYear,
  custom
}
