
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/food/add_food.dart';
import 'package:food/widgets/circular_percent_indicator.dart';
import 'package:food/widgets/linear_percent_indicator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:food/profile.dart';
import 'package:food/start/login.dart';

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
        primaryColor: const Color(0xFFff6b6b),
        useMaterial3: true
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
        colorScheme: const ColorScheme.dark(
          secondary: Color(0xFF171717),
          primary: Color(0xFF101010),
        ),
        primaryColor: const Color(0xFF8B0000),
        useMaterial3: true
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            DefaultBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(FontAwesomeIcons.fireFlameCurved),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Calories: ${(2600*0.7).round()} kcal  /  2600 kcal'),
                          LinearPercentIndicator(
                            0.7,
                            MediaQuery.of(context).size.width - 84,
                            animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward(),
                            fgColor: Colors.orange,
                            inside: const Text('70%'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularPercentIndicator(
                        0.9,
                        shouldAnimate: true,
                        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forwardAfter(100),
                        fgColor: Theme.of(context).primaryColor,
                        bgColor: Theme.of(context).colorScheme.secondary,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('90%', style: TextStyle(color: Theme.of(context).primaryColor),),
                            Text('Carbs', style: TextStyle(color: Theme.of(context).primaryColor),),
                          ]
                        ),
                      ),
                      CircularPercentIndicator(
                        0.6,
                        shouldAnimate: true,
                        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forwardAfter(200),
                        fgColor: Colors.blue.shade700,
                        bgColor: Theme.of(context).colorScheme.secondary,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('60%', style: TextStyle(color: Colors.blue.shade700),),
                            Text('Proteins', style: TextStyle(color: Colors.blue.shade700),),
                          ]
                        ),
                      ),
                      CircularPercentIndicator(
                        0.3,
                        shouldAnimate: true,
                        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forwardAfter(300),
                        fgColor: Colors.green.shade800,
                        bgColor: Theme.of(context).colorScheme.secondary,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('30%', style: TextStyle(color: Colors.green.shade800),),
                            Text('Fats', style: TextStyle(color: Colors.green.shade800),),
                          ]
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: 'FAB',
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFood())),
      ),

    );
  }
}

class DefaultBox extends StatelessWidget {
  const DefaultBox({
    this.width,
    this.height,
    this.shadows,
    this.child,
    super.key,
  });
  final Widget? child;
  final List<BoxShadow>? shadows;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadows ?? const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(3, 3)
          ),
          BoxShadow(
            color: Color(0xFF191919),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(-3, -3)
          ),
        ],
      ),
      child: child
    );
  }
}

extension on AnimationController {
  Future<void> forwardAfter(int milliseconds) async => await Future.delayed(Duration(milliseconds: milliseconds), () => forward());
}