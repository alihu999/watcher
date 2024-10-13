import '../model/employees_record.dart';

Map<int, List<EmployeesRecord>> splitDataToTables(
    List<EmployeesRecord> allData) {
  Map<int, List<EmployeesRecord>> tables = {};

  for (EmployeesRecord element in allData) {
    if (tables.containsKey(element.startAt.month)) {
      tables[element.startAt.month]!.add(element);
    } else {
      tables[element.startAt.month] = [element];
    }
  }

  return tables;
}
