import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hours/core/services/services.dart';
import 'package:hours/core/share/wait_message.dart';
import 'package:hours/view/home_page/widget/end_day_info.dart';

import '../core/database/firebase_data.dart';
import '../core/model/employee_status.dart';
import '../core/model/employees_record.dart';

abstract class EmployeController extends GetxController {
  getEmployes();
  changeEmployeStatus(EmployeeStatus employe, String status);
  EmployeesRecord getLastRecord();

  startWork();
  finishWork();
  startBreak();
  finishBreak();
  uploadData();
}

class EmployeControllerImp extends EmployeController {
  RxList<EmployeeStatus> employStatusList = <EmployeeStatus>[].obs;
  int employeIndex = 0;

  int currentId = 0;
  MyServices myServices = Get.find();

  @override
  void onInit() {
    getEmployes();

    super.onInit();
  }

  @override
  void onClose() {
    myServices.getEmployeeStatusBox().close();
    super.onClose();
  }

  @override
  getEmployes() {
    employStatusList.value = myServices
        .getEmployeeStatusBox()
        .values
        .where((element) => !element.deleted)
        .toList();
  }

  @override
  EmployeesRecord getLastRecord() {
    return myServices
        .getEmployeeRecordsBox()
        .values
        .where((element) =>
            element.employeeName == employStatusList[employeIndex].employeeName)
        .toList()
        .last;
  }

  @override
  changeEmployeStatus(EmployeeStatus employe, String status) {
    employe.status = status;
    employe.save();
    getEmployes();
  }

  @override
  startWork() async {
    changeEmployeStatus(employStatusList[employeIndex], "isStarted");
    myServices.getEmployeeRecordsBox().add(EmployeesRecord(
        employeeName: employStatusList[employeIndex].employeeName,
        startAt: DateTime.now(),
        finishAt: DateTime(2015),
        breakSAt: DateTime(2015),
        breakFAt: DateTime(2015)));
    Get.back();
  }

  @override
  finishWork() async {
    changeEmployeStatus(employStatusList[employeIndex], "isStoped");
    EmployeesRecord lastRecord = getLastRecord();
    lastRecord.finishAt = DateTime.now();
    Get.back();
    waitMassege();
    int res = await uploadRecord(lastRecord);
    if (res == 1) {
      lastRecord.uplod = true;
    }
    lastRecord.save();
    Get.back();

    endDayInfo(lastRecord);
  }

  @override
  startBreak() {
    changeEmployeStatus(employStatusList[employeIndex], "isBreaked");

    EmployeesRecord lastRecord = getLastRecord();
    lastRecord.breakSAt = DateTime.now();
    lastRecord.save();
    Get.back();
  }

  @override
  finishBreak() async {
    changeEmployeStatus(employStatusList[employeIndex], "isStarted");
    EmployeesRecord lastRecord = getLastRecord();
    lastRecord.breakFAt = DateTime.now();
    lastRecord.save();
    Get.back();
  }

  @override
  uploadData() async {
    //check internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != [ConnectivityResult.none]) {
      List<EmployeeStatus> employeeForDelete = myServices
          .getEmployeeStatusBox()
          .values
          .where((element) => element.deleted)
          .toList();
      for (EmployeeStatus rec in employeeForDelete) {
        bool res = await deletDocument(rec.employeeName);
        if (res) {
          rec.delete();
        }
      }
      List<EmployeesRecord> recordsForUpload = myServices
          .getEmployeeRecordsBox()
          .values
          .where((element) => !element.uplod || element.deleted)
          .toList();

      for (EmployeesRecord record in recordsForUpload) {
        if (!record.uplod) {
          int res = await uploadRecord(record);
          if (res == 1) {
            record.uplod = true;
            record.save();
          }
        }
        if (record.deleted == true) {
          bool resp = await deletRowFirebase(record.employeeName, record.key);
          if (resp) {
            record.delete();
          }
        }
      }
      update();
      return true;
    } else {
      return false;
    }
  }
}
