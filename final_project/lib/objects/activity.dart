class Activity {
  const Activity(
      {required this.name,
      required this.ageMin,
      required this.groupMax,
      required this.desc});
  final String name;
  final int ageMin;
  final int groupMax;
  final String desc;

  @override
  String toString() {
    return name;
  }
}

class Schedule {
  const Schedule({required this.eventName, required this.times});
  final String eventName;
  final Map<String, List<dynamic>>? times;

  @override
  String toString() {
    return "$eventName : $times";
  }

  int? getList(String hour) {
    return times?[hour]?.length;
  }

  List<dynamic>? getTimes(String hour) {
    return times?[hour];
  }

  void newGroup(String time, String groupName) {
    times?[time] = [groupName];
  }

  void addGroup(String time, String groupName) {
    times?[time]!.add(groupName);
  }
}
