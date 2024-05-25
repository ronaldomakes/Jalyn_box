import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_defenite_project/pages/home_page.dart';
import 'package:firebase_defenite_project/pages/info.dart';
import 'package:firebase_defenite_project/pages/register_page.dart';
import 'package:firebase_defenite_project/pages/welcome_screen.dart';
import 'package:firebase_defenite_project/services/firebase_api.dart';
import 'package:firebase_defenite_project/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: SplashPage()));
}
class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/img_2.png'),
      logoWidth: 250,
      backgroundColor: Colors.white,
      showLoader: true,
      loadingText: Text("Подождите...", style: GoogleFonts.openSans(
          fontSize: 30,
          fontWeight: FontWeight.w500
      ),),
      navigator: WidgetTree(),
      durationInSeconds: 5,
    );
  }
}
class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyApp();
          } else {
            return WelcomePage();
          }
        },
      ),
    );
  }
}


