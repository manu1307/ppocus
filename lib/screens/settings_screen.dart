import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocus/main.dart';
import 'package:ppocus/widgets/time_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final Controller settingController = Get.find();
  final double _currentSliderValue = 20;

  late bool autoStartSetting;
  late bool wakeLockEnable;

  @override
  void initState() {
    setState(() {
      autoStartSetting = settingController.autoStart;
      wakeLockEnable = settingController.wakeLockEnable;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        child: Column(
          children: [
            const TimeSetting(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("집중, 휴식 자동 시작"),
                  Switch(
                      value: autoStartSetting,
                      onChanged: (value) {
                        setState(() {
                          autoStartSetting = value;
                        });
                        settingController.autoStart = value;
                      })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("화면 켜진 상태 유지"),
                  Switch(
                      value: wakeLockEnable,
                      onChanged: (value) {
                        setState(() {
                          wakeLockEnable = value;
                        });
                        settingController.wakeLockEnable = value;
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
