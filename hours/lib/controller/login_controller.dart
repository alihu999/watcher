import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/core/constant/app_routes.dart';
import 'package:hours/core/model/employee_status.dart';
import 'package:hours/core/model/employees_record.dart';
import 'package:hours/core/services/services.dart';
import 'package:hours/core/share/custom_snackbar.dart';
import 'package:hours/core/share/wait_message.dart';

import '../core/database/firebase_data.dart';
import '../view/login_page/widget/restore_data_dialog.dart';

abstract class LogInController extends GetxController {
  login();
  addDataTolocalStorge();
  getShowSignUp();
}

class LogInControllerImp extends LogInController {
  late TextEditingController email;
  late TextEditingController password;

  late GlobalKey<FormState> emailFormState;
  late GlobalKey<FormState> passwordFormState;

  late FocusNode passwordFocusNode;

  Map firebaseData = {};

  MyServices myServices = Get.find();

  RxBool processLogin = false.obs;
  RxBool showPassword = false.obs;

  RxBool showSignUp = true.obs;

  @override
  void onInit() async {
    email = TextEditingController();
    password = TextEditingController();

    emailFormState = GlobalKey<FormState>();
    passwordFormState = GlobalKey<FormState>();

    passwordFocusNode = FocusNode();
    showSignUp.value = await getShowSignUp();

    super.onInit();
  }

  @override
  login() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != [ConnectivityResult.none]) {
      if (emailFormState.currentState!.validate() &&
          passwordFormState.currentState!.validate()) {
        processLogin.value = true;
        var respons =
            await firebsaeSignIn(email.text.trim(), password.text.trim());
        if (respons != null) {
          await myServices.sharedPreferences
              .setString("password", password.text.trim());
          firebaseData = await getAllFirebaseData();
          if (firebaseData.isNotEmpty) {
            Get.defaultDialog(
              title: "Restore Data",
              content: const RestoreDataContent(),
            );
          } else {
            Get.offNamed(AppRoutes.homePage);
          }
        }
        processLogin.value = false;
      }
    } else {
      errorSnackBar("check internet connection and Try again ");
    }
  }

  @override
  addDataTolocalStorge() async {
    Get.back();
    waitMassege();
    for (String employeeName in firebaseData.keys) {
      myServices
          .getEmployeeStatusBox()
          .add(EmployeeStatus(employeeName: employeeName, status: 'isStoped'));
      for (Map employeeRecord in firebaseData[employeeName]) {
        myServices.getEmployeeRecordsBox().add(EmployeesRecord(
              employeeName: employeeName,
              startAt: employeeRecord["startAt"].toDate(),
              finishAt: employeeRecord["finishAt"].toDate(),
              breakSAt: employeeRecord["breakSAt"].toDate(),
              breakFAt: employeeRecord["breakFAt"].toDate(),
            ));
      }
    }
    Get.offAllNamed(AppRoutes.homePage);
  }

  @override
  getShowSignUp() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != [ConnectivityResult.none]) {
      var response = await FirebaseFirestore.instance
          .collection('showSignUp')
          .doc('showSignUp')
          .get();
      return response.data()!["show"];
    } else {
      errorSnackBar("check internet connection and Try again ");
    }
  }
}
