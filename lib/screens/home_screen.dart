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

  late int workingTime;
  late int breakTime;
  late int totalPpoCount = 0;
  late int totalPpoTime = 0;
  late int remindTime;
  bool isReminding = false;
  bool isRemindTimerOn = true;
  bool isWorking = false;
  bool isTakingBreak = false;
  bool isTimerRunning = false;

  late bool autoStart;

  late Timer timer;
  Map<String, dynamic> proccessedDate = dateProcess(DateTime.now());

  @override
  void initState() {
    Wakelock.toggle(enable: homeController.wakeLockEnable);

    List localPpocusData = myBox.get("Daily")["data"];
    print("iniState start");

    if (!checkToday(localPpocusData[0]["year"], localPpocusData[0]["month"],
        localPpocusData[0]["day"])) {
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
    } else {
      print("date not changed");

      workTimeNum = 2;
      breakTimeNum = 3;
      // workTimeNum = homeController.workTime.toInt() * 60;
      // breakTimeNum = homeController.breakTime.toInt() * 60;
      workingTime = workTimeNum;
      breakTime = breakTimeNum;
      remindTime = homeController.remindTime.toInt();
      autoStart = homeController.autoStart;
      totalPpoCount = localPpocusData[0]["totalPpoCount"] ?? 0;
      totalPpoTime = localPpocusData[0]["totalPpoTime"] ?? 0;
      timer = Timer(const Duration(seconds: 0), () {});

      // print(todayDate.difference(DateTime(2023, 1, 3)).inDays);

      // myBox.put("Daily", {
      //   "data": [
      //     {
      //       "year": proccessedDate["year"],
      //       "month": proccessedDate["month"],
      //       "day": proccessedDate["day"],
      //       "date": proccessedDate["date"],
      //       "totalPpoCount": totalPpoCount,
      //       "totalPpoTime": totalPpoTime
      //     },
      //   ]
      // });

      // print(myBox.get("Daily")["data"]);
    }

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
    if (workingTime == 0) {
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
        workingTime = workingTime - 1;
      });
    }
    if (workingTime == remindTime * 60 && isRemindTimerOn) {
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
        workingTime = workTimeNum;
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
      workingTime = workTimeNum;
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
                formatTime(workingTime),
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
                  color: Colors.white,
                  iconSize: 50,
                ),
                if (isWorking && !autoStart)
                  IconButton(
                    onPressed: resetTimer,
                    icon: const Icon(
                      Icons.restore,
                    ),
                    color: Colors.white,
                    iconSize: 50,
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
                    inactiveThumbColor: const Color.fromARGB(255, 255, 76, 63),
                    activeColor: Colors.green,
                  )
                ],
              ),
          ]),
    );
  }
}
