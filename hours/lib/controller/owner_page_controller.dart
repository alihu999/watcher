import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/core/classes/pdf_api.dart'; // Ensure your PdfFile class is set up correctly.
import 'package:hours/core/function/split_data_to_tables.dart';
import 'package:hours/core/share/custom_snackbar.dart';
import 'package:hours/core/share/wait_message.dart';
import 'package:share_plus/share_plus.dart';

import '../core/database/firebase_data.dart';
import '../core/model/employee_status.dart';
import '../core/model/employees_record.dart';
import '../core/services/services.dart';
import '../view/employee_records.dart/widget/calculate_salary.dart';
import '../view/employee_records.dart/widget/show_change_date_dialog.dart';
import '../view/employee_records.dart/widget/show_change_time_dialog.dart';

abstract class OwnerPageController extends GetxController {
  addEmploye();
  bool employeIsExist();
  getEmployes();
  deleteEmploye(EmployeeStatus employe);
  getEmployeeTable();
  totalWorking(String month);
  changeTimeValue(String column, EmployeesRecord record);
  changeDateValue(EmployeesRecord record);
  calculateSalary(int totalminute);
  deleteRow(EmployeesRecord record);
  deleteMonthTable(int month);
  sharePdfFile(List<EmployeesRecord> records, Duration allWorkTime);
}

class OwnerPageControllerImp extends OwnerPageController {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  late GlobalKey<FormState> firstNameFormState;
  late GlobalKey<FormState> lastNameFormState;

  late FocusNode lastNameFocusNode;

  List<EmployeeStatus> employList = <EmployeeStatus>[];
  String employeeSelected = "";
  Map<String, List<Map>> splitedData = {};

  int totalMinute = 0;
  RxDouble salary = 0.0.obs;

  MyServices myServices = Get.find();

  @override
  void onInit() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();

    firstNameFormState = GlobalKey<FormState>();
    lastNameFormState = GlobalKey<FormState>();

    lastNameFocusNode = FocusNode();

    getEmployes();
    super.onInit();
  }

  @override
  getEmployes() {
    employList = myServices
        .getEmployeeStatusBox()
        .values
        .where((element) => !element.deleted)
        .toList();
  }

  @override
  addEmploye() {
    if (lastNameFormState.currentState!.validate() &&
        firstNameFormState.currentState!.validate() &&
        !employeIsExist()) {
      myServices.getEmployeeStatusBox().add(EmployeeStatus(
          employeeName:
              '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
          status: 'isStoped'));

      firstNameController.clear();
      lastNameController.clear();
      Get.back();
      successfulSnackBar("The employee record has been added successfully");

      getEmployes();
      update();
    }
  }

  @override
  employeIsExist() {
    for (int i = 0; i < employList.length; i++) {
      if (employList[i].employeeName ==
          "${firstNameController.text.trim()} ${lastNameController.text.trim()}") {
        errorSnackBar("The employee name exists");
        return true;
      }
    }
    return false;
  }

  @override
  deleteEmploye(EmployeeStatus employe) async {
    Get.back();
    waitMassege();
    bool res = await deletDocument(employe.employeeName);
    if (res) {
      myServices.getEmployeeRecordsBox().values.forEach((element) {
        if (element.employeeName == employe.employeeName) {
          element.delete();
        }
      });
      employe.delete();
    } else {
      employe.deleted = true;
      employe.save();
    }

    Get.back();
    successfulSnackBar("The employee record has been deleted successfully");
    getEmployes();
    update();
  }

  @override
  Future<Map<int, List<EmployeesRecord>>> getEmployeeTable() async {
    List<EmployeesRecord> employeeRecords = myServices
        .getEmployeeRecordsBox()
        .values
        .where((element) =>
            !element.deleted && element.employeeName == employeeSelected)
        .toList();

    return splitDataToTables(employeeRecords);
  }

  @override
  totalWorking(String month) {
    List<Map> dataTable = splitedData[month]!;
    int totalMinute = 0;
    for (Map element in dataTable) {
      totalMinute = totalMinute +
          (int.parse(element["workH"].substring(0, 2))) * 60 +
          (int.parse(element["workH"].substring(3, 5)));
    }
    return totalMinute;
  }

  @override
  changeTimeValue(String column, EmployeesRecord record) async {
    if (column == "Start At") {
      TimeOfDay? newTime = await showChangeTimeDialog(column, record.startAt);
      if (newTime !=
              TimeOfDay(
                  hour: record.startAt.hour, minute: record.startAt.minute) &&
          newTime != null) {
        record.startAt = DateTime(record.startAt.year, record.startAt.month,
            record.startAt.day, newTime.hour, newTime.minute);
        record.save();
        update();
      }
    } else {
      TimeOfDay? newTime = await showChangeTimeDialog(column, record.finishAt);
      if (newTime !=
              TimeOfDay(
                  hour: record.finishAt.hour, minute: record.finishAt.minute) &&
          newTime != null) {
        record.finishAt = DateTime(record.finishAt.year, record.finishAt.month,
            record.finishAt.day, newTime.hour, newTime.minute);
        record.save();
        update();
      }
    }
  }

  @override
  changeDateValue(EmployeesRecord record) async {
    DateTime? newDate = await showChangeDateDialog(record.startAt);
    if (newDate != null &&
        newDate !=
            DateTime(record.startAt.year, record.startAt.month,
                record.startAt.day)) {
      record.startAt = DateTime(newDate.year, newDate.month, newDate.day,
          record.startAt.hour, record.startAt.minute);
      record.save();
      update();
    }
  }

  @override
  deleteRow(EmployeesRecord record) {
    Get.defaultDialog(
        title: "Delete Row",
        titleStyle: const TextStyle(fontSize: 20),
        middleText: "Do you want to delete the Row?",
        onCancel: () {},
        onConfirm: () async {
          bool res = await deletRowFirebase(record.employeeName, record.key);
          if (res) {
            record.delete();
          } else {
            record.deleted = true;
            record.save();
          }
          Get.back();
          successfulSnackBar("The Row has been deleted");
          update();
        });
  }

  @override
  deleteMonthTable(int month) {
    Get.defaultDialog(
        title: "Delete Table",
        titleStyle: const TextStyle(fontSize: 20),
        middleText: "Do you want to delete the Table?",
        onCancel: () {},
        onConfirm: () async {
          Get.back();
          waitMassege();
          List<EmployeesRecord> monthRecord = myServices
              .getEmployeeRecordsBox()
              .values
              .where((element) => element.startAt.month == month)
              .toList();

          for (EmployeesRecord rec in monthRecord) {
            bool res = await deletRowFirebase(rec.employeeName, rec.key);
            if (res) {
              rec.delete();
            } else {
              rec.deleted = true;
              rec.save();
            }
          }
          Get.back();
          update();
        });
  }

  @override
  calculateSalary(int totalminute) {
    Get.defaultDialog(
        title: "Calculate Salary", content: const CalculateSalary());
    totalMinute = totalminute;
  }

  @override
  sharePdfFile(List<EmployeesRecord> records, Duration allWorkTime) async {
    waitMassege();
    PdfFile pdfFileIns = PdfFile();
    pdfFileIns.emloyeeRcords = records;
    pdfFileIns.totoalWork = allWorkTime;

    try {
      final File pdfFile = await pdfFileIns.generatePdf();
      // Adjust sharePositionOrigin to provide valid coordinates
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Here is the PDF of employee records.',
        sharePositionOrigin:
           const  Rect.fromLTWH(0, 0, 100, 100), // Set valid non-zero coordinates
      );
    } catch (e) {
      // Handle sharing error
      errorSnackBar("An error occurred while sharing the PDF.");
    } finally {
      Get.back(); // Close loading message
    }
  }
}
