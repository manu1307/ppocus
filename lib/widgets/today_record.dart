import 'package:flutter/material.dart';
import 'package:ppocus/main.dart';
import 'package:ppocus/utils/date_function.dart';

class TodayRecord extends StatelessWidget {
  TodayRecord({
    required this.todayPpoCount,
    required this.todayPpoTime,
    super.key,
  });

  final int todayPpoCount;
  final int todayPpoTime;
  final todayDate = dateProcess(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Card(
        color: boxColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("오늘"),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    "${todayDate['year']} / ${todayDate['month']} / ${todayDate['day']}",
                    style: const TextStyle(color: Colors.black45),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("집중 횟수 : $todayPpoCount"),
                  Text("집중 시간 : $todayPpoTime"),
                ],
              )
            ],
          ),
        ));
  }
}
