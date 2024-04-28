
// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:food/profile/settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

WeightTimePeriod weightGraphTimePeriodValue = WeightTimePeriod.month;
TextEditingController weightValueCtrl = TextEditingController();

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text('Hi ${FirebaseAuth.instance.currentUser?.displayName?.split(' ')[0] ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white,),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            constraints: const BoxConstraints(maxWidth: 124),
            onSelected: (value) async {
              if(value == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
              } else if(value == 1) {
                await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                )
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.output_rounded, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    Text('Sign out', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                  ],
                )
              )
            ]
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            
            /// profile
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.of(context).size.width * .25,
                    height: MediaQuery.of(context).size.width * .25,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(200)
                    ),
                    child: FirebaseAuth.instance.currentUser?.photoURL != null ? 
                      Image.network(FirebaseAuth.instance.currentUser!.photoURL!) :
                      Center(child: Text(FirebaseAuth.instance.currentUser?.displayName?[0] ?? '?')),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(FirebaseAuth.instance.currentUser?.displayName ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(FirebaseAuth.instance.currentUser?.email ?? '', style: const TextStyle(color: Colors.white54),),
                    ],
                  )
                ],
              ),
            ),

            DefaultBox(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Body Mass Index (BMI)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  const SizedBox(height: 6,),
                  Text(
                    '${userInfo.getBmi()} - ${userInfo.getBmiType().name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  /// arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: remap(15, 40, userInfo.getBmi(), 0, MediaQuery.of(context).size.width - 48) - 1 - (25/2)),
                      const SizedBox(
                        width: 25,
                        child: Icon(Icons.keyboard_arrow_down_rounded),
                      )
                    ],
                  ),
                  /// chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...List.generate(
                        5,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: remap(
                                0,
                                25,
                                [3.5, 6.5, 5, 5, 5][index],
                                0,
                                MediaQuery.of(context).size.width - 48
                              ) - 1,
                              height: 12,
                              decoration: BoxDecoration(
                                color: [const Color(0xFF28b6f6), const Color(0xFF66bb6a), const Color(0xFFffc928), const Color(0xFFff7143), const Color(0xFFee534f)][index],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            index < 4 ?
                              Text(['15', '18.5', '25', '30'][index], style: const TextStyle(fontWeight: FontWeight.bold),):
                              SizedBox(
                                width: remap(0, 25, 5, 0, MediaQuery.of(context).size.width - 48) - 1,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('35', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text('40', style: TextStyle(fontWeight: FontWeight.bold),),
                                  ]
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            DefaultBox(
              width: MediaQuery.of(context).size.width - 24,
              // height: MediaQuery.of(context).size.width - 24,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [

                  //*titles
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Weight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 6),
                            Text('${double.parse(((userInfo.weight[userInfo.weight.entries.map((e) => DateTime.parse(e.key.toString())).reduce((value, element) => DateTime.fromMillisecondsSinceEpoch(math.max(value.millisecondsSinceEpoch, element.millisecondsSinceEpoch)))] ?? 0) * 10).toString().split('.')[0]) / 10} kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        DropdownButton(
                          value: weightGraphTimePeriodValue.index,
                          underline: const SizedBox.shrink(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          icon: Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: Transform.rotate(
                              angle: math.pi*1.5,
                              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20)
                            ),
                          ),
                          items: [
                            DropdownMenuItem(value: WeightTimePeriod.week.index, child: const Text('Last week')),
                            DropdownMenuItem(value: WeightTimePeriod.month.index, child: const Text('Last month')),
                            DropdownMenuItem(value: WeightTimePeriod.year.index, child: const Text('Last year')),
                            DropdownMenuItem(value: WeightTimePeriod.all.index, child: const Text('All time')),
                          ],
                          onChanged: (obj) {
                            switch (obj as int) {
                              case 0:
                                setState(() {weightGraphTimePeriodValue = WeightTimePeriod.week;});break;
                              case 1:
                                setState(() {weightGraphTimePeriodValue = WeightTimePeriod.month;});break;
                              case 2:
                                setState(() {weightGraphTimePeriodValue = WeightTimePeriod.year;});break;
                              case 3:
                                setState(() {weightGraphTimePeriodValue = WeightTimePeriod.all;});break;
                              default:
                                setState(() {weightGraphTimePeriodValue = WeightTimePeriod.month;});
                            }
                          }
                        )
                      ],
                    ),
                  ),

                  //* every part of the graph 
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    height: MediaQuery.of(context).size.width - 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ///left titles
                        SizedBox(
                          width: textToSize((((userInfo.weight.values.toList().reduce((value, element) => math.max(value, element)) / 10).round() * 10) + 5).toString(), const TextStyle()).width + 8,
                          height: MediaQuery.of(context).size.width - 48 - (textToSize('Today', const TextStyle()).height + 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text((((userInfo.weight.values.toList().reduce((value, element) => math.max(value, element)) / 10).round() * 10) + 5).toString()),
                              ...List.generate(
                                (((((userInfo.weight.values.toList().reduce((value, element) => math.max(value, element)) / 10).round() * 10) + 5)  - (((userInfo.weight.values.toList().reduce((value, element) => math.min(value, element)) - 5) / 10).round() * 10)) / 5).round() - 1,
                                (index) => Text((((userInfo.weight.values.toList().reduce((value, element) => math.min(value, element)) - 5) / 10).round() * 10  + 5*(index+1)).toString())
                              ).reversed,
                              Text((((userInfo.weight.values.toList().reduce((value, element) => math.min(value, element)) - 5) / 10).round() * 10).toString()),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///graph
                            Container(
                              width: MediaQuery.of(context).size.width - 48 - (textToSize((((userInfo.weight.values.toList().reduce((value, element) => math.max(value, element)) / 10).round() * 10) + 5).toString(), const TextStyle()).width + 8),
                              height: MediaQuery.of(context).size.width - 48 - (textToSize('Today', const TextStyle()).height + 8),
                              // clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade800)
                              ),
                              child: LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: userInfo.getWeightByTime(weightGraphTimePeriodValue).keys.isNotEmpty ? DateTime.now().difference(userInfo.getWeightByTime(weightGraphTimePeriodValue).keys.reduce((value, element) => element.isBefore(value) ? element : value)).inDays.toDouble() : 0,
                                  minY: (((userInfo.weight.values.toList().reduce((value, element) => math.min(value, element)) - 5) / 10).round() * 10),
                                  maxY: (((userInfo.weight.values.toList().reduce((value, element) => math.max(value, element))  / 10).round() * 10) + 5),
                                  lineTouchData: LineTouchData(
                                    touchTooltipData: LineTouchTooltipData(
                                      tooltipBgColor: Theme.of(context).colorScheme.tertiary,
                                      tooltipRoundedRadius: 12,
                                    )
                                  ),
                                  borderData: FlBorderData(show: false),
                                  clipData: const FlClipData.all(),
                                  titlesData: const FlTitlesData(show: false,),
                                  lineBarsData: [
                                    LineChartBarData(
                                      isCurved: true,
                                      dotData: const FlDotData(show: false),
                                      barWidth: 3,
                                      color: Theme.of(context).primaryColor,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      ),
                                      spots: userInfo.getWeightByTime(weightGraphTimePeriodValue).entries.map(
                                        (e) => FlSpot(
                                          DateTime.now().difference(userInfo.getWeightByTime(weightGraphTimePeriodValue).keys.reduce((value, element) => element.isBefore(value) ? element : value)).inDays.toDouble() - DateTime.now().difference(e.key).inDays,
                                          e.value.toDouble(),
                                        )
                                      ).toList().sorted((a, b) => a.x.compareTo(b.x))
                                    ),
                                  ]
                                )
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 48 - textToSize((((userInfo.weight.values.toList().reduce((value, element) => math.max(value, element)) / 10).round() * 10) + 5).toString(), const TextStyle()).width - 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(userInfo.getWeightByTime(weightGraphTimePeriodValue).keys.isNotEmpty ? userInfo.getWeightByTime(weightGraphTimePeriodValue).keys.reduce((value, element) => element.isBefore(value) ? element : value).toString().split(' ')[0] : 'null'),
                                  const Text('Today'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //* log value button
                  DefaultBox(
                    width: MediaQuery.of(context).size.width - 48,
                    height: 40,
                    shadows: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 7.5,
                        spreadRadius: 1,
                        offset: Offset(1.5, 1.5)
                      ),
                      BoxShadow(
                        color: Color(0xFF191919),
                        blurRadius: 7.5,
                        spreadRadius: 1,
                        offset: Offset(-1.5, -1.5)
                      ),
                    ],
                    bgColor: Theme.of(context).colorScheme.primary,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: EdgeInsets.zero,
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12))
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(12),
                              margin: MediaQuery.of(context).viewInsets,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: weightValueCtrl,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(width: 2, color: Colors.white54)
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DefaultBox(
                                        width: MediaQuery.of(context).size.width / 2 - 48,
                                        height: 40,
                                        shadows: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 7.5,
                                            spreadRadius: 1,
                                            offset: Offset(1.5, 1.5)
                                          ),
                                          BoxShadow(
                                            color: Color(0xFF191919),
                                            blurRadius: 7.5,
                                            spreadRadius: 1,
                                            offset: Offset(-1.5, -1.5)
                                          ),
                                        ],
                                        bgColor: Theme.of(context).colorScheme.primary,
                                        margin: const EdgeInsets.symmetric(vertical: 12),
                                        padding: EdgeInsets.zero,
                                        child: Material(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              weightValueCtrl.clear();
                                              Navigator.pop(context);
                                            },
                                            child: const Center(child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold))),
                                          ),
                                        ),
                                      ),
                                      DefaultBox(
                                        width: MediaQuery.of(context).size.width / 2 - 48,
                                        height: 40,
                                        shadows: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 7.5,
                                            spreadRadius: 1,
                                            offset: Offset(1.5, 1.5)
                                          ),
                                          BoxShadow(
                                            color: Color(0xFF191919),
                                            blurRadius: 7.5,
                                            spreadRadius: 1,
                                            offset: Offset(-1.5, -1.5)
                                          ),
                                        ],
                                        bgColor: Theme.of(context).colorScheme.primary,
                                        margin: const EdgeInsets.symmetric(vertical: 12),
                                        padding: EdgeInsets.zero,
                                        child: Material(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              await firestore.FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).set(
                                                {
                                                  'weight': {
                                                    DateTime.now().toString().split(' ')[0]: double.parse(weightValueCtrl.text)
                                                  }
                                                },
                                                firestore.SetOptions(merge: true),
                                              );
                                              weightValueCtrl.clear();
                                              Navigator.pop(context);
                                            },
                                            child: const Center(child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ).then((value) {weightValueCtrl.clear(); setState(() {});});
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 12, right: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Log value', style: TextStyle(fontWeight: FontWeight.bold)),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),

    );
  }
}

enum WeightTimePeriod {
  week,
  month,
  year,
  all,
}