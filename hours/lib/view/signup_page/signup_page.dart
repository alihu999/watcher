import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/controller/signup_page_controller.dart';

import '../../core/constant/app_colors.dart';
import '../../core/function/validate_form.dart';
import '../../core/share/custom_textfiled.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpControllerImp controller = Get.put(SignUpControllerImp());
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width > 425 ? false : true;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(right: 25, left: 25),
            margin: isMobile
                ? null
                : EdgeInsets.only(right: width * 0.25, left: width * 0.25),
            height: height * 0.60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                      height: 45,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Create your account "),
                  ],
                ),
                CustomTextFiled(
                  lable: "Username",
                  isPassword: false,
                  filedColors: AppColors.firstColors,
                  suffixicon: const Icon(Icons.person),
                  validator: (val) => validationUserName(val!),
                  textController: controller.userName,
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (val) {
                    FocusScope.of(context)
                        .requestFocus(controller.emailFousNode);
                  },
                  formState: controller.userNameFormState,
                ),
                CustomTextFiled(
                  lable: "Email",
                  isPassword: false,
                  filedColors: AppColors.firstColors,
                  suffixicon: const Icon(Icons.email_outlined),
                  validator: (val) => validationEmail(val!),
                  textController: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (val) {
                    FocusScope.of(context)
                        .requestFocus(controller.passwordFocusNode);
                  },
                  formState: controller.emailFormState,
                  focusNode: controller.emailFousNode,
                ),
                GetX<SignUpControllerImp>(builder: (controller) {
                  return CustomTextFiled(
                    lable: "password",
                    isPassword: !controller.showPassword.value,
                    filedColors: AppColors.firstColors,
                    validator: (val) => validationPassword(val!),
                    textController: controller.password,
                    formState: controller.passwordFormState,
                    focusNode: controller.passwordFocusNode,
                    keyboardType: TextInputType.visiblePassword,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context)
                          .requestFocus(controller.rePasswordFocusNode);
                    },
                    suffixicon: IconButton(
                        onPressed: () {
                          controller.showPassword.value =
                              !controller.showPassword.value;
                        },
                        icon: Icon(
                          controller.showPassword.value
                              ? Icons.lock_open_outlined
                              : Icons.lock_outline,
                          color: AppColors.firstColors,
                        )),
                  );
                }),
                GetX<SignUpControllerImp>(builder: (controller) {
                  return CustomTextFiled(
                    lable: "Repassword",
                    isPassword: !controller.showRePassword.value,
                    filedColors: AppColors.firstColors,
                    validator: (val) {
                      if (val != controller.password.text.trim()) {
                        return "Password does not match";
                      } else {
                        return null;
                      }
                    },
                    textController: controller.rePassword,
                    formState: controller.rePasswordFormState,
                    focusNode: controller.rePasswordFocusNode,
                    keyboardType: TextInputType.visiblePassword,
                    suffixicon: IconButton(
                        onPressed: () {
                          controller.showRePassword.value =
                              !controller.showRePassword.value;
                        },
                        icon: Icon(
                          controller.showRePassword.value
                              ? Icons.lock_open_outlined
                              : Icons.lock_outline,
                          color: AppColors.firstColors,
                        )),
                  );
                }),
                GetX<SignUpControllerImp>(builder: (controller) {
                  return MaterialButton(
                      color: AppColors.firstColors,
                      height: 45,
                      onPressed: () {
                        controller.signup();
                      },
                      child: controller.processSignup.value == true
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeAlign: -2,
                            )
                          : const Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
