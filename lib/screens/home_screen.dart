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

    if (myBox.get("Daily") == null) {
      myBox.put("Daily", {"data": []});
    }
    List localPpocusData = myBox.get("Daily")["data"];

    int lastIndex = localPpocusData.isNotEmpty ? localPpocusData.length - 1 : 0;
    if (localPpocusData.isEmpty ||
        !checkToday(
            localPpocusData[lastIndex]["year"],
            localPpocusData[lastIndex]["month"],
            localPpocusData[lastIndex]["day"])) {
      //   print("date changed");
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
    List<String> hourMinuteSecond = timeDuration.split(".")[0].split(":");
    String minute = hourMinuteSecond[1];
    String second = hourMinuteSecond[2];
    String result =
        minute == "00" && second == "00" ? "60 : 00" : "$minute : $second";
    return result;
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
                ? const Text("?????? ??????")
                : const Text(
                    "?????? ??????",
                  ),
            if (isReminding && isWorking)
              Center(
                child: Text("$remindTime ??? ???????????????.\n ?????? ??? ????????????!!"),
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
            Text('?????? $totalPpoCount ??? ??????'),
            if (remindTime != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$remindTime ?????? ??????"),
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
