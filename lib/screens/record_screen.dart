import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final myBox = Hive.box("timeRecord_test_box");
  late List localPpocusData = [];
  late int todayPpoCount;

  @override
  void initState() {
    localPpocusData = myBox.get("Daily")["data"];
    Map<String, dynamic> localPpocusDataLastItem =
        localPpocusData[localPpocusData.length - 1];

    todayPpoCount = localPpocusDataLastItem['totalPpoCount'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text("오늘 $todayPpoCount"),
            DataTable(columns: const [
              DataColumn(
                  label: Expanded(
                child: Text('날짜'),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('날짜'),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('날짜'),
              ))
            ], rows: const [
              DataRow(cells: [
                DataCell(Text("2023/1/6")),
                DataCell(Text("2")),
                DataCell(Text("150"))
              ])
            ])
          ],
        ),
      ],
    );
  }
}
            //   Text(
            //       "${localPpocusData[i]["year"]} / ${localPpocusData[i]["month"]} / ${localPpocusData[i]["day"]}"),
            //   Text("${localPpocusData[i]["totalPpoCount"]}"),
            //   Text("${localPpocusData[i]["totalPpoTime"]} 분"),
