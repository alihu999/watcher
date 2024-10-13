import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hours/core/function/date_format.dart';
import 'package:hours/core/function/time_format.dart';
import '../../../controller/owner_page_controller.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/function/differnce_time.dart';
import '../../../core/function/month_name.dart';
import '../../../core/model/employees_record.dart';

class TableOfData extends StatelessWidget {
  const TableOfData({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OwnerPageControllerImp>(builder: (controller) {
      return FutureBuilder<Map<int, List<EmployeesRecord>>>(
          future: controller.getEmployeeTable(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColors.secondColors,
              ));
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text("no data available"));
            } else {
              List month = snapshot.data!.keys.toList();
              return SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 2),
                    child: Column(
                      children: List.generate(month.length, (index) {
                        Duration allWorkTime = const Duration();
                        return Column(
                          children: [
                            DataTable(
                                headingRowColor: MaterialStatePropertyAll(
                                    AppColors.secondColors),
                                headingTextStyle:
                                    const TextStyle(color: Colors.white),
                                columns: const [
                                  DataColumn(label: Text("Date")),
                                  DataColumn(label: Text("Start At")),
                                  DataColumn(label: Text("Finish At")),
                                  DataColumn(label: Text("Break Time")),
                                  DataColumn(label: Text("Work Time")),
                                ],
                                rows: List.generate(
                                    snapshot.data![month[index]]!.length,
                                    (ind) {
                                  Duration breaktime = differnceTime(
                                      snapshot
                                          .data![month[index]]![ind].breakSAt,
                                      snapshot
                                          .data![month[index]]![ind].breakFAt);
                                  Duration workTime = differnceTime(
                                          snapshot.data![month[index]]![ind]
                                              .startAt,
                                          snapshot.data![month[index]]![ind]
                                              .finishAt) -
                                      breaktime;
                                  allWorkTime = allWorkTime + workTime;
                                  return DataRow(
                                      color: MaterialStatePropertyAll(AppColors
                                          .secondColors
                                          .withOpacity(0.25)),
                                      cells: [
                                        DataCell(
                                            Text(dateFormat(snapshot
                                                .data![month[index]]![ind]
                                                .startAt)), onLongPress: () {
                                          controller.deleteRow(snapshot
                                              .data![month[index]]![ind]);
                                        }, onDoubleTap: () {
                                          controller.changeDateValue(snapshot
                                              .data![month[index]]![ind]);
                                        }),
                                        DataCell(
                                            Text(timeFormat(snapshot
                                                .data![month[index]]![ind]
                                                .startAt)), onDoubleTap: () {
                                          controller.changeTimeValue(
                                              "Start At",
                                              snapshot
                                                  .data![month[index]]![ind]);
                                        }),
                                        DataCell(
                                          Text(timeFormat(snapshot
                                              .data![month[index]]![ind]
                                              .finishAt)),
                                          onDoubleTap: () {
                                            controller.changeTimeValue(
                                                "Finish At",
                                                snapshot
                                                    .data![month[index]]![ind]);
                                          },
                                        ),
                                        DataCell(Text(
                                            "${breaktime.inHours.toString().padLeft(2, "0")}:${((breaktime.inMinutes) % 60).toString().padLeft(2, "0")}")),
                                        DataCell(Text(
                                            "${workTime.inHours.toString().padLeft(2, "0")}:${((workTime.inMinutes) % 60).toString().padLeft(2, "0")}")),
                                      ]);
                                })),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 50, bottom: 50),
                              height: 50,
                              width: 450,
                              alignment: Alignment.center,
                              color: AppColors.secondColors.withOpacity(0.25),
                              child: Text(
                                " Total Time for ${getMonthName(month[index])} ${allWorkTime.inHours} Hours &${(allWorkTime.inMinutes) % 60} Minutes ",
                              ),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.secondColors,
                                  radius: 25,
                                  child: IconButton(
                                      onPressed: () {
                                        controller.calculateSalary(
                                            allWorkTime.inMinutes);
                                      },
                                      icon: const Icon(
                                        Icons.calculate_outlined,
                                        size: 35,
                                      )),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                CircleAvatar(
                                  backgroundColor: AppColors.secondColors,
                                  radius: 25,
                                  child: IconButton(
                                      onPressed: () {
                                        controller
                                            .deleteMonthTable(month[index]);
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 35,
                                      )),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                CircleAvatar(
                                  backgroundColor: AppColors.secondColors,
                                  radius: 25,
                                  child: IconButton(
                                      onPressed: () {
                                        controller.sharePdfFile(
                                            snapshot.data![month[index]]!,
                                            allWorkTime);
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        size: 35,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              );
            }
          });
    });
  }
}
