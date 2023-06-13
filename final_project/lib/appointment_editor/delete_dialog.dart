import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:final_project/objects/event.dart';
import 'package:final_project/objects/globals.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog(this.selectedAppointment, this.events, {super.key});

  final Appointment selectedAppointment;
  final CalendarDataSource events;

  @override
  DeleteDialogState createState() => DeleteDialogState();
}

class DeleteDialogState extends State<DeleteDialog> {
  Delete _delete = Delete.event;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color defaultTextColor = Colors.black87;
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
                    'Delete recurring event',
                    style: TextStyle(
                        color: defaultTextColor, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: 20,
                ),
                RadioListTile<Delete>(
                  title: const Text('This event'),
                  value: Delete.event,
                  groupValue: _delete,
                  activeColor: const Color(0xff4169e1),
                  onChanged: (Delete? value) {
                    setState(() {
                      _delete = value!;
                    });
                  },
                ),
                RadioListTile<Delete>(
                  title: const Text('All events'),
                  value: Delete.series,
                  groupValue: _delete,
                  activeColor: const Color(0xff4169e1),
                  onChanged: (Delete? value) {
                    setState(() {
                      _delete = value!;
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
                      onPressed: () async {
                        ////Need to start the delete section here
                        ///Look at the firebase code

                        Navigator.pop(context);
                        final Appointment? parentAppointment = widget.events
                            .getPatternAppointment(
                                widget.selectedAppointment, '') as Appointment?;

                        Map<String, dynamic> appMap = {
                          "appointment": [
                            parentAppointment?.startTime,
                            parentAppointment?.endTime,
                            parentAppointment?.color.toString(),
                            parentAppointment?.startTimeZone,
                            parentAppointment?.endTimeZone,
                            parentAppointment?.notes,
                            parentAppointment?.isAllDay,
                            parentAppointment?.subject,
                            parentAppointment?.resourceIds,
                            parentAppointment?.recurrenceRule
                          ]
                        };

                        var time = parentAppointment?.startTime;
                        var hour = "${time?.hour}";
                        var name = parentAppointment?.subject;
                        DateFormat formatter = DateFormat("MM-dd-yy");
                        var docName = formatter.format(time!);
                        bool created = false;
                        Schedule? schedule;

                        CollectionReference schedules =
                            FirebaseFirestore.instance.collection("schedules");
                        final snapshot = await schedules.get();
                        if (_delete == Delete.event) {
                          if (widget.selectedAppointment.recurrenceId != null) {
                            schedules.doc(docName).delete();
                            widget.events.appointments!
                                .remove(widget.selectedAppointment);
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment]);
                          }
                          widget.events.appointments!.removeAt(widget
                              .events.appointments!
                              .indexOf(parentAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove,
                              <Appointment>[parentAppointment!]);
                          parentAppointment.recurrenceExceptionDates != null
                              ? parentAppointment.recurrenceExceptionDates!
                                  .add(widget.selectedAppointment.startTime)
                              : parentAppointment.recurrenceExceptionDates =
                                  <DateTime>[
                                  widget.selectedAppointment.startTime
                                ];
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.add,
                              <Appointment>[parentAppointment]);
                        } else {
                          if (parentAppointment!.recurrenceExceptionDates ==
                              null) {
                            schedules.doc(docName).delete();
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(parentAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[parentAppointment]);
                          } else {
                            final List<DateTime>? exceptionDates =
                                parentAppointment.recurrenceExceptionDates;
                            for (int i = 0; i < exceptionDates!.length; i++) {
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
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(parentAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[parentAppointment]);
                          }
                          db.collection("schedules").doc(docName).delete().then(
                                (doc) => debugPrint("Document deleted"),
                                onError: (e) =>
                                    debugPrint("Error updating document $e"),
                              );
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
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
