import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/objects/activity.dart';
import 'package:lake_nixon_scheduling/objects/lake_appointment.dart';
import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:lake_nixon_scheduling/widgets/activity_selector_item.dart';
import 'package:lake_nixon_scheduling/widgets/confirm_popup_dialog.dart';
import 'package:lake_nixon_scheduling/widgets/form_field_template.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

/// A page to view, add, and delete activities.
///
/// Show the user a list of the activities in Firebase, and allows them to add
/// and delete activities.
class ActivityEditor extends StatefulWidget {
  /// A page to view, add, and delete activities.
  const ActivityEditor({super.key});

  @override
  State<ActivityEditor> createState() => _ActivityEditorState();
}

class _ActivityEditorState extends State<ActivityEditor> {
  /// The index of the selected activity in the [ListView].
  int _selectedIndex = 0;

  var activityController = TextEditingController();
  var ageLimitController = TextEditingController();
  var groupSizeController = TextEditingController();
  var descController = TextEditingController();

  /// Updates the [_selectedIndex] when an activity is tapped on.
  ///
  /// A callback function called when the user taps on an [ActivitySelectorItem].
  void onActivityPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Deletes an activity when the user presses its delete button.
  ///
  /// A callback function called when the user presses the delete button on an
  /// [ActivitySelectorItem]. Deletes both the activity in question, and all
  /// appointments associated with the activity.
  void onActivityDelete(
      BuildContext context, Activity activity, AppState appState) async {
    confirmNavPopup(
        context, 'Delete Activity?', 'Deleted activities cannot be recovered.',
        (context) async {
      List<LakeAppointment> apps =
          appState.filterAppointments([], [activity.name]);

      for (LakeAppointment app in apps) {
        appState.deleteAppt(
            startTime: app.startTime!,
            subject: app.subject!,
            group: app.group!);
      }

      await appState.deleteActivity(activity);
      _selectedIndex = 0;
    });
  }

  /// Creates a pop-up dialog for creating activities.
  ///
  /// Creates a pop-up dialog takes user input for the activity properties, and
  /// adds the new activity to firebase.
  Future<void> _activityInfoPopupForm(BuildContext context) async {
    final provider = Provider.of<AppState>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Activity',
            style: Theme.of(context).textTheme.bodyLarge,
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
                      controller: activityController,
                      decoration: 'Activity',
                      formkey: "ActivityField"),
                  FormFieldTemplate(
                      controller: ageLimitController,
                      decoration: 'Age Limit',
                      formkey: "MarkField",
                      keyboardType: TextInputType.number),
                  FormFieldTemplate(
                      controller: groupSizeController,
                      decoration: 'Group Size',
                      formkey: "YearField",
                      keyboardType: TextInputType.number),
                  FormFieldTemplate(
                      controller: descController,
                      decoration: 'Description',
                      formkey: "DescField")
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.nixonGreen)),
              onPressed: () async {
                // This is how you get the database from Firebase

                if (provider.nameInActivities(activityController.text)) {
                  Fluttertoast.showToast(
                      msg: "EVENT NAME ALREADY IN USE",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  provider.createActivity(
                      provider.firestore,
                      activityController.text,
                      int.parse(ageLimitController.text),
                      int.parse(groupSizeController.text),
                      descController.text);

                  activityController.clear();
                  ageLimitController.clear();
                  groupSizeController.clear();
                  descController.clear();
                  Navigator.pop(context);
                }
              },
              child:
                  Text('Add', style: Theme.of(context).textTheme.smallButton),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.nixonGreen)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel',
                  style: Theme.of(context).textTheme.smallButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Select Activity',
              style: Theme.of(context).textTheme.appBarTitle),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _activityInfoPopupForm(context);
                  });
                },
                icon: const Icon(Icons.add))
          ]),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<AppState>(
          builder: (BuildContext context, AppState appState, Widget? child) {
            return ListView.builder(
                itemCount: appState.activities.length,
                itemBuilder: (BuildContext context, int index) {
                  return ActivitySelectorItem(
                      appState.activities[index],
                      _selectedIndex == index,
                      index,
                      onActivityPressed,
                      onActivityDelete);
                });
          },
        ),
      ),
    );
  }
}
