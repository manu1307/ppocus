import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ppocus/screens/home_screen.dart';
import 'package:ppocus/screens/record_screen.dart';
import 'package:ppocus/screens/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

var blackFontcolor = const Color(0xff2d2d2d);
var selectedColor = const Color(0xffAA1945);
var backgroundColor = const Color(0xffF9F1F0);
var appBarBackgroundColor = const Color(0xffFADCD9);
var boxColor = const Color(0xffF79489);
var inactiveColor = const Color(0xffF8AFA6);

class Controller extends GetxController {
  var count = 0.obs;
  var workTime = 25.obs;
  var breakTime = 5.obs;
  var remindTime = 5.obs;
  var autoStart = false;
  var wakeLockEnable = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox("timeRecord_test_box");

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
          appBarTheme: AppBarTheme(
            backgroundColor: appBarBackgroundColor,
          ),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: TextTheme(
            bodyMedium: TextStyle(
              color: blackFontcolor,
              fontFamily: GoogleFonts.gothicA1().fontFamily,
              fontSize: 16,
            ),
          ),
          sliderTheme: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
            thumbColor: selectedColor,
            activeTrackColor: selectedColor,
            inactiveTrackColor: inactiveColor,
            activeTickMarkColor: selectedColor,
            inactiveTickMarkColor: inactiveColor,
          ),
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected) ? selectedColor : null),
            trackColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected) ? inactiveColor : null),
          ),
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _screenOptions.elementAt(_selectedIndex)["title"],
            style: TextStyle(color: blackFontcolor),
          ),
        ),
      ),
      body: SafeArea(
        child: _screenOptions.elementAt(_selectedIndex)["screen"],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: selectedColor),
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
