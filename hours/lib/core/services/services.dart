import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/employee_status.dart';
import '../model/employees_record.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  Future<MyServices> init() async {
    await initHiveBox();
    sharedPreferences = await SharedPreferences.getInstance();

    return this;
  }

  initHiveBox() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EmployeeStatusAdapter());
    Hive.registerAdapter(EmployeesRecordAdapter());

    await Hive.openBox<EmployeeStatus>("EmployeeStatusBox");
    await Hive.openBox<EmployeesRecord>("EmployeeRecordsBox");
  }

  Box<EmployeeStatus> getEmployeeStatusBox() =>
      Hive.box<EmployeeStatus>("EmployeeStatusBox");
  Box<EmployeesRecord> getEmployeeRecordsBox() =>
      Hive.box<EmployeesRecord>("EmployeeRecordsBox");
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
