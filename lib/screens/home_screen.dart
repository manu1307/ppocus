import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ppocus/main.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Controller homeController = Get.put(Controller());
  final myBox = Hive.box("timeRecord_box");

  late int workTimeNum;
  late int breakTimeNum;

  late int workingTime;
  late int breakTime;
  int totalPomodoro = 0;
  late int remindTime;
  bool remindTimeOn = true;
  bool isWorking = false;
  bool isTakingBreak = false;
  bool remind = false;
  bool isTimerRunning = false;
//   테스트 중
  late bool autoStart;

  late Timer timer;

  @override
  void initState() {
    Wakelock.toggle(enable: homeController.wakeLockEnable);
    // workTimeNum = 2;
    // breakTimeNum = 3;
    workTimeNum = homeController.workTime.toInt() * 60;
    breakTimeNum = homeController.breakTime.toInt() * 60;
    workingTime = workTimeNum;
    breakTime = breakTimeNum;
    remindTime = homeController.remindTime.toInt();
    autoStart = homeController.autoStart;

    // var todayDate = DateTime(2023, 1, 12);
    // var testDate = DateTime(2023, 1, 9);
    // print(todayDate.day);
    // print(todayDate.month);
    // print(todayDate.year);
    // print(todayDate.add(const Duration(hours: 24)));
    // print(todayDate.add(const Duration(hours: 36)));

    // myBox.put("daily", {});
    // myBox.put("test2", "WTF");
    // print(myBox.get("test"));
    // myBox.put("test", "data changed");
    // print(myBox.get("test"));
    super.initState();
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
        totalPomodoro = totalPomodoro + 1;
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
    if (workingTime == remindTime * 60 && remindTimeOn) {
      remind = true;
      Vibration.vibrate(duration: 750);
      Timer(const Duration(seconds: 5), () {
        remind = false;
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
      remindTimeOn = value;
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
            if (remind && isWorking)
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
            Text('오늘 $totalPomodoro 뽀 완료'),
            if (remindTime != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$remindTime 분전 알림"),
                  Switch(
                    value: remindTimeOn,
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
