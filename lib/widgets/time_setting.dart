import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocus/main.dart';

class TimeSetting extends StatefulWidget {
  const TimeSetting({super.key});

  @override
  State<TimeSetting> createState() => _TimeSettingState();
}

class _TimeSettingState extends State<TimeSetting> {
  final Controller timeController = Get.find();
  double _workTimeSliderValue = 25;
  double _breakTimeSliderValue = 5;
  double _remindTimeSliderValue = 5;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx((() {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "집중시간",
                    ),
                    Text("${timeController.workTime} 분"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Slider.adaptive(
                    value: timeController.workTime.toDouble(),
                    min: 0,
                    max: 60,
                    divisions: 12,
                    onChanged: (value) {
                      setState(() {
                        _workTimeSliderValue = value;
                      });
                      timeController.workTime =
                          RxInt(_workTimeSliderValue.toInt());
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("휴식시간"),
                    Text("${timeController.breakTime} 분"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Slider.adaptive(
                    value: timeController.breakTime.toDouble(),
                    min: 0,
                    max: 30,
                    divisions: 6,
                    onChanged: (value) {
                      setState(() {
                        _breakTimeSliderValue = value;
                      });
                      timeController.breakTime =
                          RxInt(_breakTimeSliderValue.toInt());
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("미리 알림"),
                    Text("${timeController.remindTime} 분 전"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Slider.adaptive(
                    value: timeController.remindTime.toDouble(),
                    min: 0,
                    max: 30,
                    divisions: 3,
                    onChanged: (value) {
                      setState(() {
                        _remindTimeSliderValue = value;
                      });
                      timeController.remindTime =
                          RxInt(_remindTimeSliderValue.toInt());
                    }),
              ),
            ],
          );
        })),
      ],
    );
  }
}
