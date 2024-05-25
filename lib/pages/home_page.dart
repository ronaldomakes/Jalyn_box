import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_defenite_project/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/alarm_notification.dart';
import '../services/firebase_auth.dart';
import '../widgets/star_rating_widget.dart';
import 'info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool flame = false;
  int mq9 = 40;
  int _selectedIndex = 0;
  int temperature = 0;
  final GlobalKey<_ProgressBarState> progressBarKey = GlobalKey();

  double calculateRating(int mq9Value) {
    // Implement your logic to calculate rating based on MQ-9 value
    // This is an example, adjust thresholds and ratings as needed
    if (mq9Value >= 1000) {
      return 5.0;
    } else if (mq9Value >= 800) {
      return 4.0;
    } else if (mq9Value >= 600) {
      return 3.0;
    } else if (mq9Value >= 400) {
      return 2.0;
    } else {
      return 1.0;
    }
  }


  String getTextBasedOnRating(int mq9) {
    double rating = calculateRating(mq9);
    if (rating >= 5.0) {
      return 'Очень высокий';
    } else if (rating >= 4.0) {
      return 'Высокий';
    } else if (rating >= 3.0) {
      return 'Средний';
    } else if (rating >= 2.0) {
      return 'Низкий';
    } else {
      return 'Нормальный';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Navigate to Info Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InfoPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Noti.initialize(FlutterLocalNotificationsPlugin());
    _listenForData();
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }
  Future<void> _listenForData() async {
    FirebaseDatabase.instance.ref().child('User').onValue.listen((snapshot) {
      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map;
        bool flameStatus = data['Flame sensor']['Status'];
        int mq9Value = data['MQ-9 sensor']['Value'];
        setState(() {
          mq9 = mq9Value;
          flame = flameStatus;
          isLoading = false;
        });
        int mq9threeshold = 500;
        if (mq9Value > mq9threeshold && flameStatus == true) {
          Noti.showBigTextNotification(
              title: "Ваш дом горит!",
              body: "Позвоните ближайшим соседям чтобы спасти детей",
              fln: FlutterLocalNotificationsPlugin());
        }

        progressBarKey.currentState?.updateValue(mq9Value.toDouble());
      } else {
        print('No data available.');
      }
    });
  }

  void readData() async {
    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child('User').get();
    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map;
      bool flameStatus = await data['Flame sensor']['Status'];
      int mq9Value = await data['MQ-9 sensor']['Value'];
      setState(() {
        mq9 = mq9Value;
        flame = flameStatus;
        isLoading = false;
      });
      int mq9threeshold = 500;
      if (mq9Value > mq9threeshold && flameStatus == true) {
        Noti.showBigTextNotification(
            title: "Ваш дом горит!",
            body: "Позвоните ближайшим соседям чтобы спасти детей",
            fln: FlutterLocalNotificationsPlugin());
      }

      progressBarKey.currentState?.updateValue(mq9Value.toDouble());
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Главный экран',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Color(0xFF3AAC3F),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Значение с датчиков дыма',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(height: 10),
                  SizedBox(
                      width: 350,
                      height: 350,
                      child: ProgressBar(coLevel: mq9, key: progressBarKey)),
                  Padding(padding: EdgeInsets.only(left: 100),
                  child: Column(
                    children: [

                      StarRating(mq9Value: mq9),
                    ],
                  )),
                  Text(
                    'Уровень опасности: ${getTextBasedOnRating(mq9)}',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF3AAC3F),
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главный экран',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Информация')
        ],
      ),
    );
  }
}

class ProgressBar extends StatefulWidget {
  final int coLevel;
  final Key? key; // Add this line

  ProgressBar({required this.coLevel, this.key}) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    double value = widget.coLevel.toDouble();
    Color color;
    if (value < 200) {
      color = Colors.green;
    } else if (value < 500) {
      color = Colors.yellow;
    } else if (value < 700) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    return DashedCircularProgressBar.aspectRatio(
      aspectRatio: 1,
      // width ÷ height
      valueNotifier: _valueNotifier,
      progress: value,
      startAngle: 225,
      sweepAngle: 270,
      maxProgress: 1000,
      foregroundColor: color,
      backgroundColor: const Color(0xffeeeeee),
      foregroundStrokeWidth: 15,
      backgroundStrokeWidth: 15,
      animation: true,
      seekSize: 6,
      seekColor: const Color(0xffeeeeee),
      child: Center(
        child: ValueListenableBuilder(
            valueListenable: _valueNotifier,
            builder: (_, double value, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${(value / 10).toInt()}%',
                        style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 60)),
                    Text(
                      'Уровень газа',
                      style: const TextStyle(
                          color: Color(0xff65a63a),
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ],
                )),
      ),
    );
  }

  void updateValue(double newValue) {
    _valueNotifier.value = newValue;
  }
}
