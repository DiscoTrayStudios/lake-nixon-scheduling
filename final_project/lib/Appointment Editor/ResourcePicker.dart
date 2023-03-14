import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'CalendarTimeZonePicker.dart';

class ResourcePicker extends StatefulWidget {
  const ResourcePicker(this.resourceCollection, {required this.onChanged});

  final List<CalendarResource> resourceCollection;

  final PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() => ResourcePickerState();
}

class ResourcePickerState extends State<ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSwatch(
              backgroundColor: const Color(0xff4169e1),
            )),
        child: AlertDialog(
          content: SizedBox(
              width: double.maxFinite,
              height: (widget.resourceCollection.length * 50).toDouble(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.resourceCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  final CalendarResource resource =
                      widget.resourceCollection[index];
                  return SizedBox(
                      height: 50,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff4169e1),
                          backgroundImage: resource.image,
                          child: resource.image == null
                              ? Text(resource.displayName[0])
                              : null,
                        ),
                        title: Text(resource.displayName),
                        onTap: () {
                          setState(() {
                            widget.onChanged(
                                PickerChangedDetails(resourceId: resource.id));
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