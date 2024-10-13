import 'package:hive_flutter/hive_flutter.dart';

part 'employees_record.g.dart';

@HiveType(typeId: 0)
class EmployeesRecord extends HiveObject {
  @HiveField(0)
  String employeeName;
  @HiveField(1)
  DateTime startAt;
  @HiveField(2)
  DateTime finishAt;
  @HiveField(3)
  DateTime breakSAt;
  @HiveField(4)
  DateTime breakFAt;
  @HiveField(5)
  bool uplod;
  @HiveField(6)
  bool deleted;

  EmployeesRecord(
      {required this.employeeName,
      required this.startAt,
      required this.finishAt,
      required this.breakSAt,
      required this.breakFAt,
      this.uplod = false,
      this.deleted = false});
}
