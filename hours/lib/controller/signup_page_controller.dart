import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constant/app_routes.dart';
import '../core/database/firebase_data.dart';
import '../core/services/services.dart';
import '../core/share/custom_snackbar.dart';

abstract class SignUpController extends GetxController {
  signup();
}

class SignUpControllerImp extends SignUpController {
  late TextEditingController userName;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController rePassword;

  late GlobalKey<FormState> userNameFormState;
  late GlobalKey<FormState> emailFormState;
  late GlobalKey<FormState> passwordFormState;
  late GlobalKey<FormState> rePasswordFormState;

  late FocusNode emailFousNode;
  late FocusNode passwordFocusNode;
  late FocusNode rePasswordFocusNode;

  RxBool showPassword = false.obs;
  RxBool showRePassword = false.obs;
  RxBool processSignup = false.obs;

  MyServices myServices = Get.find();

  @override
  void onInit() {
    userName = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    rePassword = TextEditingController();

    userNameFormState = GlobalKey<FormState>();
    emailFormState = GlobalKey<FormState>();
    passwordFormState = GlobalKey<FormState>();
    rePasswordFormState = GlobalKey<FormState>();

    emailFousNode = FocusNode();
    passwordFocusNode = FocusNode();
    rePasswordFocusNode = FocusNode();

    super.onInit();
  }

  @override
  signup() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != [ConnectivityResult.none]) {
      if (userNameFormState.currentState!.validate() &&
          emailFormState.currentState!.validate() &&
          passwordFormState.currentState!.validate() &&
          rePasswordFormState.currentState!.validate()) {
        processSignup.value = true;
        var respons =
            await firebaseSignUp(email.text.trim(), password.text.trim());
        if (respons != null) {
          await myServices.sharedPreferences
              .setString("password", password.text.trim());
          Get.offNamed(AppRoutes.homePage);
        }
        processSignup.value = false;
      }
    } else {
      errorSnackBar("check internet connection and Try again ");
    }
  }
}
