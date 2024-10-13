import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/controller/employe_controller.dart';
import 'package:hours/core/constant/app_colors.dart';

import 'employe_dialog.dart';

class EmployeList extends StatelessWidget {
  const EmployeList({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width > 450 ? false : true;

    return Container(
      color: AppColors.firstColors.withOpacity(0.25),
      width: isMobile ? width : 225,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: GetX<EmployeControllerImp>(builder: (controller) {
        if (controller.employStatusList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "no data availables,Add employee records",
              style: TextStyle(fontSize: 17),
            ),
          );
        } else {
          return ListView.builder(
              itemCount: controller.employStatusList.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(
                      bottom: 7, top: 7, right: 10, left: 10),
                  title: Text(
                    controller.employStatusList[index].employeeName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(
                    Icons.fiber_manual_record,
                    color:
                        controller.employStatusList[index].status == "isStoped"
                            ? Colors.red
                            : controller.employStatusList[index].status ==
                                    "isStarted"
                                ? Colors.green
                                : Colors.blue,
                  ),
                  onTap: () {
                    controller.employeIndex = index;
                    Get.defaultDialog(
                        title: controller.employStatusList[index].employeeName,
                        titleStyle: const TextStyle(fontSize: 25),
                        content: const EmployeDialog());
                  },
                );
              }));
        }
      }),
    );
  }
}
