
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food/widgets/circular_percent_indicator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:food/profile.dart';
import 'package:food/login.dart';

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
      title: 'Food',
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFffffff),
        colorScheme: const ColorScheme.dark(
          secondary: Color(0xFFe8e8e8),
          primary: Color(0xFFffffff),
        ),
        primaryColor: const Color(0xFFff6b6b)
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
        colorScheme: const ColorScheme.dark(
          secondary: Color(0xFF171717),
          primary: Color(0xFF101010),
        ),
        primaryColor: const Color(0xFF6B0000)
      ),
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

class _AppState extends State<App> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(15/2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(80)
            ),
            child: Material(
              borderRadius: BorderRadius.circular(80),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(80),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())),
                child: FirebaseAuth.instance.currentUser?.photoURL != null ? Image.network(FirebaseAuth.instance.currentUser!.photoURL!) : null
              )
            )
          ),
        ],
      ),

      body: Center(
        child: CircularPercentIndicator(
          0.7,
          shouldAnimate: true,
          animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..forward(),
          fgColor: Theme.of(context).primaryColor,
          bgColor: Theme.of(context).colorScheme.secondary,
          center: const Text('70%'),
        ),
      ),

    );
  }
}