
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/firebase_options.dart';
import 'package:food/food/add_food.dart';
import 'package:food/start/intro.dart';
import 'package:food/widgets/circular_percent_indicator.dart';
import 'package:food/widgets/food_tile.dart';
import 'package:food/widgets/linear_percent_indicator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:food/profile/profile.dart';
import 'package:food/start/login.dart';
import 'dart:math' as math;

void main() async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

final googleSignIn = GoogleSignIn();
late UserAmounts userInfo;

/// Extracted from iOS 13.2 Beta.
const Color _kActiveTickColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFF3C3C44),
  darkColor: Color(0xFFEBEBF5),
);

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
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF8B0000),
        scaffoldBackgroundColor: const Color(0xFF141414),
        appBarTheme: const AppBarTheme(
          // backgroundColor: Color(0xFF141414),
          backgroundColor: Color(0xFF1b1b1b),
          centerTitle: true,
          elevation: 1,
          shadowColor: Colors.black
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF141414),
          secondary: Color(0xFF202020),
          tertiary: Color(0xFF323232),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return const Login();
          } else {
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snap) {

                /// if values in database are null -> get them from the user / otherwise -> get the from the database and store them locally
                if(snap.data?.data()?['calories'] != null &&
                  snap.data?.data()?['carbs'] != null &&
                  snap.data?.data()?['proteins'] != null &&
                  snap.data?.data()?['fats'] != null &&
                  snap.data?.data()?['height'] != null &&
                  snap.data?.data()?['weight'] != null                  
                ) {
                  userInfo = UserAmounts._init_(
                      snap.data!.data()!['height'],
                      (snap.data!.data()!['weight'] as Map<String, dynamic>).cast<String, num>().map((key, value) => MapEntry(DateTime.parse(key), value)),
                      snap.data!.data()!['calories'],
                      snap.data!.data()!['carbs'],
                      snap.data!.data()!['proteins'],
                      snap.data!.data()!['fats'],
                    );
                  return const App();
                } else {
                  return const Intro();
                }
              }
            );
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

      extendBodyBehindAppBar: true,
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(200),
        leading: const IconButton(onPressed: null, icon: Icon(FontAwesomeIcons.calendarDays),),//TODO
        middle: Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
        trailing: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(15/2),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())),
              child: FirebaseAuth.instance.currentUser?.photoURL != null ? Image.network(FirebaseAuth.instance.currentUser!.photoURL!, fit: BoxFit.cover,) : null
            )
          )
        ),
      ),

      body: FutureBuilder<MainPageInfo>(//TODO: change to stream builder
        future: () async {
          DocumentSnapshot<Map> foods = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}').get();
          List<FoodEntry> awaitedFoods = [];
          for (int food = 0; food < (foods.data()?.entries.length ?? 0); food++) {
            var currentFood = foods.data()?.entries.toList()[food];
            FoodEntry foodEntry = await FoodEntry.fromDiary(currentFood?.value['id'], currentFood?.value['amount'], currentFood?.key);
            awaitedFoods.add(foodEntry);
          }
          return MainPageInfo(awaitedFoods, userInfo);
        }.call(),
        builder: (context, snapshot) {
          return RefreshIndicator.adaptive(
            color: _kActiveTickColor,
            edgeOffset: 40,
            onRefresh: () async {setState(() {});},
            child: ListView(
              padding: const EdgeInsets.all(12),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [

                SizedBox(height: MediaQuery.of(context).padding.top),

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
                              Text('Calories: ${(snapshot.data?.kcal ?? 0).round()} kcal  /  ${snapshot.data?.userInfo.kcal ?? 0} kcal'),
                              LinearPercentIndicator(
                                ((snapshot.data?.kcal ?? 0) / (snapshot.data?.userInfo.kcal ?? 0)).non().clamp(0, 1).toDouble(),
                                MediaQuery.of(context).size.width - 84,
                                animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward(),
                                fgColor: Colors.orange,
                                bgColor: Theme.of(context).colorScheme.primary,
                                inside: Text('${(((snapshot.data?.kcal ?? 0) / (snapshot.data?.userInfo.kcal ?? 0)).non() * 100).round()}%'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CircularPercentIndicator(
                                ((snapshot.data?.carbs ?? 0) / (snapshot.data?.userInfo.carbs ?? 0)).non().clamp(0, 1).toDouble(),
                                shouldAnimate: true,
                                animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forwardAfter(100),
                                fgColor: Theme.of(context).primaryColor,
                                bgColor: Theme.of(context).colorScheme.primary,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${((((snapshot.data?.carbs ?? 0) / (snapshot.data?.userInfo.carbs ?? 0)).non()) * 100).clamp(0, double.infinity).round()}%', style: TextStyle(color: Theme.of(context).primaryColor),),
                                    Text('Carbs', style: TextStyle(color: Theme.of(context).primaryColor),),
                                  ]
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('${((snapshot.data?.userInfo.carbs ?? 0) - (snapshot.data?.carbs ?? 0)).clamp(0, double.infinity)}g left', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),)
                            ],
                          ),
                          Column(
                            children: [
                              CircularPercentIndicator(
                                ((snapshot.data?.proteins ?? 0) / (snapshot.data?.userInfo.proteins ?? 0)).non().clamp(0, 1).toDouble(),
                                shouldAnimate: true,
                                animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forwardAfter(200),
                                fgColor: Colors.blue.shade700,
                                bgColor: Theme.of(context).colorScheme.primary,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${((((snapshot.data?.proteins ?? 0) / (snapshot.data?.userInfo.proteins ?? 0)).non()) * 100).clamp(0, double.infinity).round()}%', style: TextStyle(color: Colors.blue.shade700),),
                                    Text('Proteins', style: TextStyle(color: Colors.blue.shade700),),
                                  ]
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('${((snapshot.data?.userInfo.proteins ?? 0) - (snapshot.data?.proteins ?? 0)).clamp(0, double.infinity)}g left', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),)
                            ],
                          ),
                          Column(
                            children: [
                              CircularPercentIndicator(
                                ((snapshot.data?.fats ?? 0) / (snapshot.data?.userInfo.fats ?? 0)).non().clamp(0, 1).toDouble(),
                                shouldAnimate: true,
                                animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forwardAfter(300),
                                fgColor: Colors.green.shade800,
                                bgColor: Theme.of(context).colorScheme.primary,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${((((snapshot.data?.fats ?? 0) / (snapshot.data?.userInfo.fats ?? 0)).non()) * 100).clamp(0, double.infinity).round()}%', style: TextStyle(color: Colors.green.shade800),),
                                    Text('Fats', style: TextStyle(color: Colors.green.shade800),),
                                  ]
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('${((snapshot.data?.userInfo.fats ?? 0) - (snapshot.data?.fats ?? 0)).clamp(0, double.infinity)}g left', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 6),
                
                if(snapshot.data != null) ...snapshot.data!.foods.sorted((a, b) => a.diaryId.compareTo(b.diaryId)).map(
                  (e) =>  FoodEntryTile(e, () => setState(() {}), margin: const EdgeInsets.symmetric(vertical: 6),)
                )
          
              ],
            ),
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFood())).then((value) => setState(() {})),
      ),

    );
  }
}

class DefaultBox extends StatelessWidget {
  const DefaultBox({
    this.width,
    this.height,
    this.bgColor,
    this.shadows = false,
    this.child,
    this.margin,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });
  final Widget? child;
  final Color? bgColor;
  final bool shadows;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      margin: margin,
      padding: padding,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadows ? const [
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
        ]:null,
      ),
      child: child
    );
  }
}

extension on AnimationController {
  Future<void> forwardAfter(int milliseconds) async => await Future.delayed(Duration(milliseconds: milliseconds), () => forward());
}

class MainPageInfo {

  MainPageInfo(this.foods, this.userInfo);

  final List<FoodEntry> foods;
  final UserAmounts userInfo;

  int get kcal {
    int total = 0;
    for (var food in foods) {
      total = total + food.calculateKcal;
    }
    return total;
  }
  int get carbs {
    int total = 0;
    for (var food in foods) {
      total = total + food.calculateCarbs;
    }
    return total;
  }
  int get proteins {
    int total = 0;
    for (var food in foods) {
      total = total + food.calculateProteins;
    }
    return total;
  }
  int get fats {
    int total = 0;
    for (var food in foods) {
      total = total + food.calculateFats;
    }
    return total;
  }

}

class UserAmounts {

  UserAmounts._init_(
    this.height,
    this.weight,
    this.kcal,
    this.carbs,
    this.proteins,
    this.fats,
  );

  static Future<UserAmounts> get() async {
    DocumentSnapshot<Map> doc = await FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).get();
    return UserAmounts._init_(
      doc.data()?['height'] ?? 0,
      (doc.data()?['weight'] as Map<String, dynamic>?)?.cast<String, num>().map((key, value) => MapEntry(DateTime.parse(key), value)) ?? <DateTime, num>{},
      doc.data()?['calories'] ?? 0,
      doc.data()?['carbs'] ?? 0,
      doc.data()?['proteins'] ?? 0,
      doc.data()?['fats'] ?? 0,
    );
  }

  double getBmi() => ((double.parse(((userInfo.weight[userInfo.weight.entries.map((e) => DateTime.parse(e.key.toString())).reduce((value, element) => DateTime.fromMillisecondsSinceEpoch(math.max(value.millisecondsSinceEpoch, element.millisecondsSinceEpoch)))] ?? 0) * 10).toString().split('.')[0]) / 10) / (userInfo.height * userInfo.height) * 100000).round() / 10;
  BmiType getBmiType() {
    if(getBmi() < 18.5) {
      return BmiType.underweight;
    } else if(getBmi() < 25) {
      return BmiType.normal;
    } else if(getBmi() < 30) {
      return BmiType.overweight;
    } else if(getBmi() < 35) {
      return BmiType.obesity1;
    } else if(getBmi() < 40) {
      return BmiType.obesity2;
    } else {
      return BmiType.obesity3;
    }
  }

  Map<DateTime, num> getWeightByTime(WeightTimePeriod time) {
    if(time == WeightTimePeriod.week) {
      return { for (var it in weight.entries.where((element) => DateTime.now().difference(element.key).inDays < 8 ? true : false)) (it).key : (it).value };
    } else if(time == WeightTimePeriod.month) {
      return { for (var it in weight.entries.where((element) => DateTime.now().difference(element.key).inDays < 31 ? true : false)) (it).key : (it).value };
    } else if(time == WeightTimePeriod.year) {
      return { for (var it in weight.entries.where((element) => DateTime.now().difference(element.key).inDays < 365 ? true : false)) (it).key : (it).value };
    } else {
      return weight;
    }
  }

  final int height;
  final Map<DateTime, num> weight;
  final int kcal;
  final int carbs;
  final int proteins;
  final int fats;

  @override
  String toString() {
    return 'UserAmounts($height, $weight, $kcal, $carbs, $proteins, $fats)';
  }

}

enum BmiType {
  underweight,
  normal,
  overweight,
  obesity1,
  obesity2,
  obesity3,
}

extension on num {

  num non() {
    if(isNaN || isInfinite) {
      return 0;
    } else {
      return this;
    }
  }

}

extension Sorting<E> on List<E> {

  List<E> sorted([int Function(E, E)? compare]) {
    List<E> sortedList = this;
    sortedList.sort(compare);
    return sortedList;
  }

}

double remap(num inMin, num inMax, num value, num outMin, num outMax) {
  return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin);
}

Size textToSize(String text, TextStyle style) {
  TextPainter painter = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr);
  painter.layout();
  return painter.size;
}

enum WeightUnit {
  kg,
  lbs
}
enum HeightUnit {
  cm,
  inch,
}
enum VolumeUnit {
  ml,
  floz,
}