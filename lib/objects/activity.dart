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
