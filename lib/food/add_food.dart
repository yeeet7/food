
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/food/food.dart';
import 'package:food/widgets/food_tile.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

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

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).collection('foods').get(),
      builder: (context, snapshot) {
        return StatefulBuilder(
          builder: (context, setstate) {
            return Scaffold(

              body: SuperScaffold(

                appBar: SuperAppBar(
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(200),
                  leading: CupertinoNavigationBarBackButton(previousPageTitle: 'Back',color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, onPressed: () => Navigator.pop(context),),
                  title: const Text('Foods', style: TextStyle(color: Colors.white)),
                  largeTitle: SuperLargeTitle(largeTitle: 'Foods'),
                  searchBar: SuperSearchBar(
                    scrollBehavior: SearchBarScrollBehavior.pinned,
                    cancelTextStyle: TextStyle(color: Theme.of(context).primaryColor),
                    searchFocusNode: addFoodNode,
                    searchController: addFoodController,
                    resultBehavior: SearchBarResultBehavior.neverVisible,
                    onSubmitted: (value) => setState(() {}),
                  ),
                ),

                body: ListView(
                  padding: const EdgeInsets.all(6),
                  shrinkWrap: true,
                  children: [
                    ...snapshot.data?.docs.where((element) => (element.data()['name'] as String).contains(addFoodController.text)).map<Widget>(
                      (e) => FoodTile(
                        Food(
                          id: e.id,
                          name: e.data()['name'] ?? 'name',
                          amount: e.data()['amount'] ?? 1,
                          imagePath: e.data()['imagePath'],
                          unit: Unit.values.elementAt(e.data()['unit']),
                          notes: e.data()['notes'] ?? '',
                          kcal: e.data()['calories'] ?? 0.0,
                          carbs: e.data()['carbs'] ?? 0.0,
                          proteins: e.data()['proteins'] ?? 0.0,
                          fats: e.data()['fats'] ?? 0.0
                        ),
                        setstate: () {setState(() {});},
                      )
                    ).toList() ?? [],
                  ]
                ),
              ),
      
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FoodWidget(FoodIntent.create, () => setState(() {})))),
                child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
              ),

            );
          }
        );
      }
    );
  }
}