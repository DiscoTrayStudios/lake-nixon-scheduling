import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/activity.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/widgets/activity_selector_item.dart';
import 'package:final_project/widgets/form_field_template.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ActivityEditor extends StatefulWidget {
  const ActivityEditor({super.key});

  @override
  State<ActivityEditor> createState() => _ActivityEditorState();
}

class _ActivityEditorState extends State<ActivityEditor> {
  int _selectedIndex = 0;

  var activityController = TextEditingController();
  var ageLimitController = TextEditingController();
  var groupSizeController = TextEditingController();
  var descController = TextEditingController();

  void onActivityPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onActivityDelete(Activity activity, AppState appState) async {
    List<LakeAppointment> apps =
        appState.lakeAppointmentsByActivity(activity.name);

    for (LakeAppointment app in apps) {
      appState.deleteAppt(
          startTime: app.startTime!, subject: app.subject!, group: app.group!);
    }

    await appState.deleteActivity(activity);
    _selectedIndex = 0;
  }

  Future<void> _activityInfoPopupForm(BuildContext context) async {
    final provider = Provider.of<AppState>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Activity',
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              key: const Key("OKButton"),
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
      appBar: AppBar(title: const Text('Select Activity'), actions: [
        IconButton(
            onPressed: () {
              setState(() {
                _activityInfoPopupForm(context);
              });
            },
            icon: const Icon(Icons.add))
      ]),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          return ListView.separated(
              itemCount: appState.activities.length,
              itemBuilder: (BuildContext context, int index) {
                return ActivitySelectorItem(
                    appState.activities[index],
                    _selectedIndex == index,
                    index,
                    onActivityPressed,
                    onActivityDelete);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              });
        },
      ),
    );
  }
}
