import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/core/constant/app_colors.dart';

Future<DateTime?> showChangeDateDialog(DateTime initValue) {
  return showDatePicker(
    context: Get.context!,
    firstDate: DateTime(2010),
    lastDate: DateTime(2050),
    initialDate: initValue,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    barrierDismissible: false,
    builder: (context, Widget? child) {
      return Theme(
        data: ThemeData(
          colorSchemeSeed: AppColors.secondColors,
          datePickerTheme: DatePickerThemeData(
              surfaceTintColor: Colors.white,
              confirmButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.secondColors),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              headerForegroundColor: Colors.white,
              headerBackgroundColor: AppColors.secondColors),
        ),
        child: child!,
      );
    },
  );
}
