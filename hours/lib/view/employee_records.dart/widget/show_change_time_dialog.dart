import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/core/constant/app_colors.dart';

showChangeTimeDialog(String column, DateTime value) {
  return showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(
        hour: value.hour,
        minute: value.minute,
      ),
      barrierDismissible: false,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      helpText: "Edite $column value",
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
                dialHandColor: AppColors.secondColors,
                entryModeIconColor: AppColors.secondColors,
                helpTextStyle: const TextStyle(fontSize: 17),
                confirmButtonStyle: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.secondColors),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white))),
          ),
          child: child!,
        );
      });
}
