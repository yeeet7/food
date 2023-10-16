
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  late final TextEditingController kcalCtrl;
  late final TextEditingController carbsCtrl;
  late final TextEditingController proteinsCtrl;
  late final TextEditingController fatsCtrl;
  late final TextEditingController heightCtrl;
  late final TextEditingController weightCtrl;
  
  late final FocusNode kcalNode;
  late final FocusNode carbsNode;
  late final FocusNode proteinsNode;
  late final FocusNode fatsNode;
  late final FocusNode heightNode;
  late final FocusNode weightNode;

  @override
  void initState() {
    super.initState();
    kcalCtrl = TextEditingController();
    carbsCtrl = TextEditingController();
    proteinsCtrl = TextEditingController();
    fatsCtrl = TextEditingController();
    heightCtrl = TextEditingController();
    weightCtrl = TextEditingController();

    kcalNode = FocusNode();
    carbsNode = FocusNode();
    proteinsNode = FocusNode();
    fatsNode = FocusNode();
    heightNode = FocusNode();
    weightNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Container(
            margin: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48 - 24) / 2,
                  child: TextField(
                    onTapOutside: (event) => [heightNode, weightNode, kcalNode, carbsNode, proteinsNode, fatsNode][index].unfocus(),
                    controller: [heightCtrl, weightCtrl, kcalCtrl, carbsCtrl, proteinsCtrl, fatsCtrl][index],
                    focusNode: [heightNode, weightNode, kcalNode, carbsNode, proteinsNode, fatsNode][index],
                    cursorColor: Colors.white70,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      suffix: Text(['cm', 'kg', 'kcal', 'g', 'g', 'g'][index], style: const TextStyle(color: Colors.white30),),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent)
                      ),
                    ),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 48 - 24) / 2,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(['Height', 'Weight', 'Calories', 'Carbohydrates', 'Proteins', 'Fats'][index]),
                ),
              ],
            ),
          )
        )
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
        label: Text('Submit', style: TextStyle(color: Theme.of(context).primaryColor),),
        onPressed: () async {
          if(kcalCtrl.text.isEmpty || carbsCtrl.text.isEmpty || proteinsCtrl.text.isEmpty || fatsCtrl.text.isEmpty) return;
          FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).set({
            'height': int.parse(heightCtrl.text),
            'weight': {
              DateTime.now().toString(): double.parse(weightCtrl.text)
            },
            'calories': int.parse(kcalCtrl.text),
            'carbs': int.parse(carbsCtrl.text),
            'proteins': int.parse(proteinsCtrl.text),
            'fats': int.parse(fatsCtrl.text),
          });
        },
      ),

    );
  }
}