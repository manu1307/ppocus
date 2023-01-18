import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ppocus/main.dart';
import 'package:ppocus/utils/date_function.dart';
import 'package:ppocus/widgets/today_record.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final myBox = Hive.box("timeRecord_test_box");
  late List localPpocusData = [];
  late int todayPpoCount;
  late int todayPpoTime;

  late int numberOfColumntoShow;

  final todayDate = dateProcess(DateTime.now());

  @override
  void initState() {
    localPpocusData = myBox.get("Daily")["data"];
    Map todayPpocusDataLastItem = localPpocusData[localPpocusData.length - 1];

    todayPpoCount = todayPpocusDataLastItem['totalPpoCount'];
    todayPpoTime = todayPpocusDataLastItem['totalPpoTime'];

    numberOfColumntoShow =
        localPpocusData.length > 7 ? 7 : localPpocusData.length;

    print(todayDate["year"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: Column(
        children: [
          TodayRecord(
            todayPpoCount: todayPpoCount,
            todayPpoTime: todayPpoTime,
          ),
          const SizedBox(
            height: 30,
          ),
          Title(color: blackFontcolor, child: const Text("최근 집중 기록")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DataTable(
                  headingTextStyle: TextStyle(
                    color: selectedColor,
                    fontSize: 15.5,
                  ),
                  dataTextStyle: TextStyle(
                    fontSize: 13,
                    color: blackFontcolor,
                  ),
                  columns: const [
                    DataColumn(
                        label: Text(
                      '날짜',
                    )),
                    DataColumn(
                        label: Text(
                      '집중 횟수',
                    )),
                    DataColumn(
                        label: Text(
                      '집중 시간',
                    ))
                  ],
                  rows: [
                    for (var i = 0; i < numberOfColumntoShow; i++)
                      DataRow(cells: [
                        DataCell(Text(
                            "${localPpocusData[i]["year"]} / ${localPpocusData[i]["month"]} / ${localPpocusData[i]["day"]}")),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${localPpocusData[i]["totalPpoCount"]}"),
                          ],
                        )),
                        DataCell(
                            Text("${localPpocusData[i]["totalPpoTime"]} 분")),
                      ])
                  ])
            ],
          )
        ],
      ),
    ));
  }
}
