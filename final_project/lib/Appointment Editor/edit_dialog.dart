import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Objects/globals.dart';

class EditDialog extends StatefulWidget {
  const EditDialog(this.newAppointment, this.selectedAppointment,
      this.recurrenceProperties, this.events, {super.key});

  final Appointment newAppointment, selectedAppointment;
  final RecurrenceProperties? recurrenceProperties;
  final CalendarDataSource events;

  @override
  EditDialogState createState() => EditDialogState();
}

class EditDialogState extends State<EditDialog> {
  Edit _edit = Edit.event;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color defaultTextColor = Colors.white;
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: 380,
          height: 210,
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 370,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 25, top: 5),
                  child: const Text(
                    'Save recurring event',
                    style: TextStyle(
                        color: defaultTextColor, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: 20,
                ),
                RadioListTile<Edit>(
                  title: const Text('This event'),
                  value: Edit.event,
                  groupValue: _edit,
                  activeColor: const Color(0xff4169e1),
                  onChanged: (Edit? value) {
                    setState(() {
                      _edit = value!;
                    });
                  },
                ),
                RadioListTile<Edit>(
                  title: const Text('All events'),
                  value: Edit.series,
                  groupValue: _edit,
                  activeColor: const Color(0xff4169e1),
                  onChanged: (Edit? value) {
                    setState(() {
                      _edit = value!;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Color(0xff4169e1),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        if (_edit == Edit.event) {
                          final Appointment? parentAppointment = widget.events
                                  .getPatternAppointment(
                                      widget.selectedAppointment, '')
                              as Appointment?;

                          final Appointment newAppointment = Appointment(
                              startTime: widget.newAppointment.startTime,
                              endTime: widget.newAppointment.endTime,
                              color: widget.newAppointment.color,
                              notes: widget.newAppointment.notes,
                              isAllDay: widget.newAppointment.isAllDay,
                              location: widget.newAppointment.location,
                              subject: widget.newAppointment.subject,
                              resourceIds: widget.newAppointment.resourceIds,
                              id: widget.selectedAppointment.appointmentType ==
                                      AppointmentType.changedOccurrence
                                  ? widget.selectedAppointment.id
                                  : null,
                              recurrenceId: parentAppointment!.id,
                              startTimeZone:
                                  widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone);

                          parentAppointment.recurrenceExceptionDates != null
                              ? parentAppointment.recurrenceExceptionDates!
                                  .add(widget.selectedAppointment.startTime)
                              : parentAppointment.recurrenceExceptionDates =
                                  <DateTime>[
                                  widget.selectedAppointment.startTime
                                ];
                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(parentAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment]);
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment]);
                          if (widget.selectedAppointment.appointmentType ==
                              AppointmentType.changedOccurrence) {
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment]);
                          }
                          widget.events.appointments!.add(newAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[newAppointment]);
                        } else {
                          Appointment? parentAppointment = widget.events
                                  .getPatternAppointment(
                                      widget.selectedAppointment, '')
                              as Appointment?;
                          final List<DateTime>? exceptionDates =
                              parentAppointment!.recurrenceExceptionDates;
                          if (exceptionDates != null &&
                              exceptionDates.isNotEmpty) {
                            for (int i = 0; i < exceptionDates.length; i++) {
                              final Appointment? changedOccurrence =
                                  widget.events.getOccurrenceAppointment(
                                      parentAppointment, exceptionDates[i], '');
                              if (changedOccurrence != null) {
                                widget.events.appointments!
                                    .remove(changedOccurrence);
                                widget.events.notifyListeners(
                                    CalendarDataSourceAction.remove,
                                    <Appointment>[changedOccurrence]);
                              }
                            }
                          }

                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(parentAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment]);
                          DateTime startDate, endDate;
                          if ((widget.newAppointment.startTime)
                              .isBefore(parentAppointment.startTime)) {
                            startDate = widget.newAppointment.startTime;
                            endDate = widget.newAppointment.endTime;
                          } else {
                            startDate = DateTime(
                                parentAppointment.startTime.year,
                                parentAppointment.startTime.month,
                                parentAppointment.startTime.day,
                                widget.newAppointment.startTime.hour,
                                widget.newAppointment.startTime.minute);
                            endDate = DateTime(
                                parentAppointment.endTime.year,
                                parentAppointment.endTime.month,
                                parentAppointment.endTime.day,
                                widget.newAppointment.endTime.hour,
                                widget.newAppointment.endTime.minute);
                          }
                          parentAppointment = Appointment(
                              startTime: startDate,
                              endTime: endDate,
                              color: widget.newAppointment.color,
                              notes: widget.newAppointment.notes,
                              isAllDay: widget.newAppointment.isAllDay,
                              location: widget.newAppointment.location,
                              subject: widget.newAppointment.subject,
                              resourceIds: widget.newAppointment.resourceIds,
                              id: parentAppointment.id,
                              recurrenceRule:
                                  widget.recurrenceProperties == null
                                      ? null
                                      : SfCalendar.generateRRule(
                                          widget.recurrenceProperties!,
                                          startDate,
                                          endDate),
                              startTimeZone:
                                  widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone);
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment]);
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff4169e1),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
