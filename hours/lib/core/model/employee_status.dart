import 'package:hive_flutter/hive_flutter.dart';

part 'employee_status.g.dart';

@HiveType(typeId: 1)
class EmployeeStatus extends HiveObject {
  @HiveField(0)
  String employeeName;
  @HiveField(1)
  String status;
  @HiveField(2)
  bool deleted;

  EmployeeStatus(
      {required this.employeeName, required this.status, this.deleted = false});
}
