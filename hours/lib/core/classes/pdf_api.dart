import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:hours/core/function/date_format.dart';
import 'package:hours/core/function/differnce_time.dart';
import 'package:hours/core/function/time_format.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart';

import '../function/month_name.dart';
import '../model/employees_record.dart';

class PdfFile {
  List<EmployeesRecord> emloyeeRcords = [];
  Duration totoalWork = const Duration();
  Future<File> generatePdf() async {
    final pdf = Document();
    var logo = await buildLogo();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              Center(
                child: Image(logo, width: 200),
              ),
              SizedBox(height: 50),
              Text("Name: ${emloyeeRcords[0].employeeName}",
                  style: const TextStyle(fontSize: 17)),
              SizedBox(height: 20),
              buildtable(),
              SizedBox(height: 70),
              totolTime()
            ]));

    return saveDocument(
        name:
            "${emloyeeRcords[0].employeeName} ${getMonthName(emloyeeRcords[0].startAt.month)}.pdf",
        pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  Widget buildtable() {
    List header = ["Date", "Start At", "Finish At", "Break Time", "Work Time"];
    return TableHelper.fromTextArray(
        headers: header,
        headerAlignment: Alignment.center,
        cellAlignment: Alignment.center,
        border: TableBorder.all(
          width: 1,
        ),
        //   headerStyle: const TextStyle(color: PdfColors.white),
        //    headerDecoration: BoxDecoration(color: PdfColor.fromHex("#ce0505")),
        //    rowDecoration: BoxDecoration(color: PdfColor.fromHex("#f3bdbf")),
        data: List.generate(emloyeeRcords.length, (index) {
          Duration breakTime = differnceTime(
              emloyeeRcords[index].breakSAt, emloyeeRcords[index].breakFAt);
          Duration workTime = differnceTime(
              emloyeeRcords[index].startAt, emloyeeRcords[index].finishAt);
          return [
            dateFormat(emloyeeRcords[index].startAt),
            timeFormat(emloyeeRcords[index].startAt),
            timeFormat(emloyeeRcords[index].finishAt),
            "${breakTime.inHours.toString().padLeft(2, "0")}:${((breakTime.inMinutes) % 60).toString().padLeft(2, "0")}",
            "${workTime.inHours.toString().padLeft(2, "0")}:${((workTime.inMinutes) % 60).toString().padLeft(2, "0")}"
          ];
        }));
  }

  buildLogo() async {
    final ByteData bytes = await rootBundle.load("assets/images/splash.png");
    final Uint8List byteList = bytes.buffer.asUint8List();
    final image = MemoryImage(byteList);
    return image;
  }

  Widget totolTime() {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Text(
          "Total Work Time for ${getMonthName(emloyeeRcords[0].startAt.month)}: ${totoalWork.inHours} Hours & ${(totoalWork.inMinutes) % 60} Minute ",
          style: const TextStyle(fontSize: 15)),
    );
  }
}
/*

 */