import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/event.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/widgets/event_selector_item.dart';
import 'package:final_project/widgets/form_field_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventEditor extends StatefulWidget {
  const EventEditor({super.key});

  @override
  State<EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {
  int _selectedIndex = 0;

  var eventController = TextEditingController();
  var ageLimitController = TextEditingController();
  var groupSizeController = TextEditingController();
  var descController = TextEditingController();

  void onEventPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onEventDelete(Event event, AppState appState) async {
    List<LakeAppointment> apps = appState.lakeAppointmentsByEvent(event.name);

    for (LakeAppointment app in apps) {
      appState.deleteAppt(
          startTime: app.startTime!, subject: app.subject!, group: app.group!);
    }

    await appState.deleteEvent(event);
    _selectedIndex = 0;
  }

  Future<void> _eventInfoPopupForm(BuildContext context) async {
    final provider = Provider.of<AppState>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Event',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  // call FormFieldTemplate for each
                  // will allow for easier universal use for future code iterations
                  FormFieldTemplate(
                      controller: eventController,
                      decoration: 'Event',
                      formkey: "EventField"),
                  FormFieldTemplate(
                      controller: ageLimitController,
                      decoration: 'Age Limit',
                      formkey: "MarkField"),
                  FormFieldTemplate(
                      controller: groupSizeController,
                      decoration: 'Group Size',
                      formkey: "YearField"),
                  FormFieldTemplate(
                      controller: descController,
                      decoration: 'Description',
                      formkey: "DescField")
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              key: const Key("OKButton"),
              onPressed: () async {
                // This is how you get the database from Firebase

                provider.createEvent(
                    provider.firestore,
                    eventController.text,
                    int.parse(ageLimitController.text),
                    int.parse(groupSizeController.text),
                    descController.text);

                eventController.clear();
                ageLimitController.clear();
                groupSizeController.clear();
                descController.clear();
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Select Event')),
        body: Consumer<AppState>(
          builder: (BuildContext context, AppState appState, Widget? child) {
            return ListView.separated(
                itemCount: appState.events.length,
                itemBuilder: (BuildContext context, int index) {
                  return EventSelectorItem(
                      appState.events[index],
                      _selectedIndex == index,
                      index,
                      onEventPressed,
                      onEventDelete);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                });
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _eventInfoPopupForm(context);
              });
            },
            child: const Icon(Icons.add)));
  }
}
