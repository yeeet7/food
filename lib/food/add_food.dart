
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/food/food.dart';
import 'package:food/widgets/food_tile.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  @override
  Widget build(BuildContext context) {

  final addFoodController = TextEditingController();
  final addFoodNode = FocusNode();

    return Hero(
      tag: 'FAB',
      child: Scaffold(
    
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextField(
            controller: addFoodController,
            cursorColor: Colors.white54,
            focusNode: addFoodNode,
            onTapOutside: (event) => addFoodNode.unfocus(),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              hintText: 'Search',
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              fillColor: Theme.of(context).colorScheme.primary,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: .2)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 1)
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodWidget(FoodIntent.create))),
            )
          ],
        ),
    
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).collection('foods').get(),
          builder: (context, snapshot) {
            log(snapshot.data?.docs.map((e) => e.data()).toString() ?? '');
            // List<Food> foods = snapshot.data?.docs.map((e) => Food());
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: snapshot.data?.docs.map<Widget>(
                  (e) => FoodTile(
                    Food(
                      id: e.id,
                      name: e.data()['name'] ?? 'name',
                      amount: e.data()['amount'] ?? 1,
                      unit: Unit.values.elementAt(e.data()['unit']),
                      kcal: e.data()['calories'] ?? 0,
                      carbs: e.data()['carbs'] ?? 0,
                      proteins: e.data()['proteins'] ?? 0,
                      fats: e.data()['fats'] ?? 0
                    ),
                    onDelete: () async {
                      await FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).collection('foods').doc(e.id).delete();
                      setState(() {});
                    },
                  )
                ).toList() ?? [],
                //TODO: filter by search
              ),
            );
          }
        )
    
      ),
    );
  }
}