
// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/food/food.dart';

class FoodTile extends StatelessWidget {
  const FoodTile(this.food, {this.intent = FoodIntent.add, required this.setstate, super.key});

  final void Function() setstate;
  final FoodIntent intent;
  final Food food;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FoodWidget(intent, setstate, food: food,))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Icon(FontAwesomeIcons.appleWhole, color: Theme.of(context).primaryColor,),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          Row(
                            children: [
                              Text('${food.kcal}kcal  ', style: const TextStyle(fontSize: 12, color: Colors.orange)),
                              Text('${food.carbs}g  ', style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
                              Text('${food.proteins}g  ', style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
                              Text('${food.fats}g  ', style: TextStyle(fontSize: 12, color: Colors.green.shade800)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  PopupMenuButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).colorScheme.secondary,
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white70,),
                    onSelected: (value) async {
                      switch(value) {
                        case 0:
                          await FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).collection('foods').doc(food.id).delete();
                          setstate.call();
                          break;
                        case 1:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FoodWidget(FoodIntent.edit, setstate, food: food,))).then((value) => setstate.call());
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('delete'),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text('edit'),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodEntryTile extends StatelessWidget {
  const FoodEntryTile(this.foodEntry, this.setstate, {this.margin = const EdgeInsets.all(6), super.key});
  final FoodEntry foodEntry;
  final EdgeInsets? margin;
  final void Function()? setstate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FoodWidget(FoodIntent.view, () {}, food: foodEntry))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Icon(FontAwesomeIcons.appleWhole, color: Theme.of(context).primaryColor,),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${foodEntry.diaryAmount}${foodEntry.unit == Unit.gram ? 'g' : foodEntry.unit == Unit.milliliter ? 'ml' : 'x'} - ${foodEntry.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          Row(
                            children: [
                              Text('${foodEntry.kcal}kcal  ', style: const TextStyle(fontSize: 12, color: Colors.orange)),
                              Text('${foodEntry.carbs}g  ', style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
                              Text('${foodEntry.proteins}g  ', style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
                              Text('${foodEntry.fats}g  ', style: TextStyle(fontSize: 12, color: Colors.green.shade800)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  PopupMenuButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).colorScheme.secondary,
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white70,),
                    onSelected: (value) async {
                      switch(value) {
                        case 0:
                          Map? foods = (await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}').get()).data();
                          foods?.remove(foodEntry.diaryId);
                          await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}').set((foods ?? {}) as Map<String, dynamic>);
                          setstate?.call();
                          break;
                        case 1:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FoodWidget(FoodIntent.editInDiary, () {setstate?.call();}, food: foodEntry))).then((value) => setstate?.call());
                          setstate?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('delete'),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text('edit'),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Food {

  Food({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.amount,
    required this.unit,
    required this.kcal,
    required this.carbs,
    required this.proteins,
    required this.fats,
  });

  final String id;
  final String? imagePath;
  final String name;
  final Unit unit;
  final int amount;
  final int kcal;
  final num carbs;
  final num proteins;
  final num fats;

  @override
  String toString() {
    return 'Food($name)';
  }

}

class FoodEntry extends Food {

  FoodEntry._({
    required this.diaryAmount,
    required this.diaryId,
    required super.name,
    required super.unit,
    required super.amount,
    required super.id,
    required super.imagePath,
    required super.kcal,
    required super.carbs,
    required super.proteins,
    required super.fats,
  });

  final int diaryAmount;
  final String diaryId;

  int get calculateKcal => (kcal/amount*diaryAmount).round();
  int get calculateCarbs => (carbs/amount*diaryAmount).round();
  int get calculateProteins => (proteins/amount*diaryAmount).round();
  int get calculateFats => (fats/amount*diaryAmount).round();

  static Future<FoodEntry> fromDiary(String id, int amount, String diaryId) async {
    QuerySnapshot<Map<String, dynamic>> all = await FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).collection('foods').get();
    QueryDocumentSnapshot<Map<String, dynamic>> food = all.docs.where((e) => e.id == id).first;
    return FoodEntry._(
      id: id,
      diaryId: diaryId,
      imagePath: food.data()['imagePath'],
      diaryAmount: amount,
      name: food.data()['name'],
      amount: food.data()['amount'],
      unit: Unit.values.elementAt(food.data()['unit']),
      kcal: food.data()['calories'],
      carbs: food.data()['carbs'],
      proteins: food.data()['proteins'],
      fats: food.data()['fats'],
    );
  }

}