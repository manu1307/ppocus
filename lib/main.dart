import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppocus/screens/home_screen.dart';
import 'package:ppocus/screens/record_screen.dart';
import 'package:ppocus/screens/settings_screen.dart';

class Controller extends GetxController {
  var count = 0.obs;
  var workTime = 25.obs;
  var breakTime = 5.obs;
  var remindTime = 5.obs;
  var autoStart = false;
  var wakeLockEnable = false;
  increment(int number) => count + number;
}

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff175873),
          ),
          scaffoldBackgroundColor: const Color(0xff2B7C85),
          textTheme: TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.gothicA1().fontFamily,
              fontSize: 16,
            ),
          ),
          sliderTheme: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
            activeTickMarkColor: Colors.red,
            thumbColor: Colors.red,
          ),
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  final List<Map<String, dynamic>> _screenOptions = [
    {"screen": const RecordScreen(), "title": "통계"},
    {"screen": const HomeScreen(), "title": "PPocus"},
    {"screen": const SettingScreen(), "title": "설정"},
  ];

  void _onItemTapped(int index) {
    // print(_selectedIndex);
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(_screenOptions.elementAt(_selectedIndex)["title"]),
        ),
      ),
      body: SafeArea(
        child: _screenOptions.elementAt(_selectedIndex)["screen"],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart_rounded,
              size: 30,
            ),
            label: "통계",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 30,
            ),
            label: "설정",
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
