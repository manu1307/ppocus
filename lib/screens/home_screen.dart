import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ppocus/main.dart';
import 'package:ppocus/utils/check_today_funtcion.dart';
import 'package:ppocus/utils/date_function.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Controller homeController = Get.put(Controller());
  final myBox = Hive.box("timeRecord_test_box");

  late int workTimeNum;
  late int breakTimeNum;

  late int workTime;
  late int breakTime;
  late int totalPpoCount;
  late int totalPpoTime;
  late int remindTime;
  bool isReminding = false;
  bool isRemindTimerOn = true;
  bool isWorking = false;
  bool isTakingBreak = false;
  bool isTimerRunning = false;

  late bool autoStart;

  late Timer timer = Timer(const Duration(minutes: 0), () {});
  Map<String, dynamic> proccessedDate = dateProcess(DateTime.now());

  @override
  void initState() {
    Wakelock.toggle(enable: homeController.wakeLockEnable);

    myBox.put("Daily", {
      "data": [
        {
          "year": 2023,
          "month": 1,
          "day": 13,
          "date": DateTime(2023, 1, 13),
          "totalPpoCount": 3,
          "totalPpoTime": 180,
        },
        {
          "year": 2023,
          "month": 1,
          "day": 14,
          "date": DateTime(2023, 1, 14),
          "totalPpoCount": 5,
          "totalPpoTime": 155,
        },
        {
          "year": 2023,
          "month": 1,
          "day": 15,
          "date": DateTime(2023, 1, 15),
          "totalPpoCount": 4,
          "totalPpoTime": 210,
        },
        {
          "year": 2023,
          "month": 1,
          "day": 16,
          "date": DateTime(2023, 1, 16),
          "totalPpoCount": 8,
          "totalPpoTime": 220,
        },
      ]
    });

    List localPpocusData = myBox.get("Daily")["data"];

    int lastIndex = localPpocusData.length - 1;
    if (!checkToday(
        localPpocusData[lastIndex]["year"],
        localPpocusData[lastIndex]["month"],
        localPpocusData[lastIndex]["day"])) {
      print("date changed");
      myBox.put("Daily", {
        "data": [
          ...localPpocusData,
          {
            "year": proccessedDate["year"],
            "month": proccessedDate["month"],
            "day": proccessedDate["day"],
            "date": proccessedDate["date"],
            "totalPpoCount": 0,
            "totalPpoTime": 0,
          },
        ]
      });

      localPpocusData = myBox.get("Daily")["data"];
      lastIndex = localPpocusData.length - 1;
      //   print(localPpocusData);
    }
    print(localPpocusData);

    workTimeNum = homeController.workTime.toInt() * 60;
    breakTimeNum = homeController.breakTime.toInt() * 60;
    workTime = workTimeNum;
    breakTime = breakTimeNum;
    remindTime = homeController.remindTime.toInt();
    autoStart = homeController.autoStart;
    totalPpoCount = localPpocusData[lastIndex]["totalPpoCount"] ?? 0;
    totalPpoTime = localPpocusData[lastIndex]["totalPpoTime"] ?? 0;

    super.initState();
  }

  void updateDailyData(int totalPpoCount, int totalPpoTime) {
    myBox.put("Daily", {
      "data": [
        {
          "year": proccessedDate["year"],
          "month": proccessedDate["month"],
          "day": proccessedDate["day"],
          "date": proccessedDate["date"],
          "totalPpoCount": totalPpoCount,
          "totalPpoTime": totalPpoTime
        },
      ]
    });
    print(myBox.get("Daily")['data']);
  }

  String formatTime(int time) {
    var timeDuration = Duration(seconds: time).toString();
    var hourMinuteSecond = timeDuration.split(".")[0].split(":");
    var minute = hourMinuteSecond[1];
    var second = hourMinuteSecond[2];
    return "$minute : $second";
  }

  void onTickWorkingTimer(Timer timer) {
    if (workTime == 0) {
      if (isWorking) {
        totalPpoCount = totalPpoCount + 1;
        totalPpoTime = totalPpoTime + workTimeNum;
        updateDailyData(totalPpoCount, totalPpoTime);
      }
      setState(() {
        breakTime = breakTimeNum;
        isWorking = false;
        isTakingBreak = true;
        if (!autoStart) {
          isTimerRunning = false;
        }
      });
      timer.cancel();

      if (autoStart) {
        startTimer();
      }
    } else {
      setState(() {
        workTime = workTime - 1;
      });
    }
    if (workTime == remindTime * 60 && isRemindTimerOn) {
      isReminding = true;
      Vibration.vibrate(duration: 750);
      Timer(const Duration(seconds: 5), () {
        isReminding = false;
      });
    }
  }

  void onTickBreakTimer(Timer timer) {
    if (breakTime == 0) {
      setState(() {
        isWorking = true;
        isTakingBreak = false;
        workTime = workTimeNum;
        if (!autoStart) {
          isTimerRunning = false;
        }
      });

      timer.cancel();
      if (autoStart) {
        startTimer();
      }
    } else {
      setState(() {
        breakTime = breakTime - 1;
      });
    }
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
    });
    if (isWorking || (!isWorking && !isTakingBreak)) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        onTickWorkingTimer(timer);
      });
      setState(() {
        isWorking = true;
      });
    } else if (isTakingBreak) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        onTickBreakTimer(timer);
      });
      setState(() {
        isTakingBreak = true;
      });
    }
  }

  void pauseTimer() {
    setState(() {
      isTimerRunning = false;
    });
    if (isWorking) {
      setState(() {
        isWorking = false;
      });
    }
    timer.cancel();
  }

  void resetTimer() {
    setState(() {
      isTimerRunning = false;
      isWorking = false;
      workTime = workTimeNum;
    });
    timer.cancel();
  }

  void toggleRemindTime(bool value) {
    setState(() {
      isRemindTimerOn = value;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isTakingBreak
                ? const Text("쉬는 시간")
                : const Text(
                    "집중 시간",
                  ),
            if (isReminding && isWorking)
              Center(
                child: Text("$remindTime 분 남았습니다.\n 좀만 더 힘내세요!!"),
              ),
            if (isTakingBreak)
              Text(
                formatTime(breakTime),
                style: const TextStyle(
                  fontSize: 60,
                ),
              ),
            if (isWorking || (!isWorking && !isTakingBreak))
              Text(
                formatTime(workTime),
                style: const TextStyle(
                  fontSize: 60,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: isTimerRunning ? pauseTimer : startTimer,
                  icon: Icon(isTimerRunning
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded),
                  color: const Color(0xff2d2d2d),
                  iconSize: 60,
                ),
                IconButton(
                  onPressed: resetTimer,
                  icon: const Icon(
                    Icons.restore,
                  ),
                  color: const Color(0xff2d2d2d),
                  iconSize: 60,
                )
              ],
            ),
            Text('오늘 $totalPpoCount 뽀 완료'),
            if (remindTime != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$remindTime 분전 알림"),
                  Switch(
                    value: isRemindTimerOn,
                    onChanged: toggleRemindTime,
                  )
                ],
              ),
          ]),
    );
  }
}
