import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/core/constant/app_colors.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/function/date_format.dart';
import '../../../core/function/differnce_time.dart';
import '../../../core/function/time_format.dart';
import '../../../core/model/employees_record.dart';

endDayInfo(EmployeesRecord record) {
  Duration breakH = differnceTime(record.breakSAt, record.breakFAt);
  Duration workH = differnceTime(record.startAt, record.finishAt) - breakH;
  String massages = """
Date: ${dateFormat(record.startAt)}
Started work At: ${timeFormat(record.startAt)}
Finish work At: ${timeFormat(record.finishAt)}
Break For: ${breakH.inHours} hour & ${breakH.inMinutes % 60} minute
Work For: ${workH.inHours} hour & ${workH.inMinutes % 60} minute
""";
  return Get.defaultDialog(
    title: record.employeeName,
    content: SizedBox(
      height: 200,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            massages,
            style: const TextStyle(height: 1.6),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  label: const Text(
                    "OK",
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  )),
              ElevatedButton.icon(
                  onPressed: () async {
                    await Share.share(massages);
                  },
                  icon: Icon(
                    Icons.share_outlined,
                    color: AppColors.firstColors,
                    size: 20,
                  ),
                  label: Text(
                    "Share",
                    style:
                        TextStyle(color: AppColors.firstColors, fontSize: 14),
                  ))
            ],
          )
        ],
      ),
    ),
  );
}
