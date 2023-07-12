
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:macros/profile.dart';
import 'package:macros/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final googleSignIn = GoogleSignIn();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Macros',
      themeMode: ThemeMode.system,
      theme: ThemeData(primarySwatch: Colors.green,),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.green),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return const Login();
          } else {
            return const App();
          }
        },
      )
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  
  final main = const Main();
  final profile = const Profile();

  int currentIndex =  0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: [main, profile][currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(FontAwesomeIcons.calendarCheck)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(FontAwesomeIcons.user)),
        ]
      ),

    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}