
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/food/food.dart';

class FoodTile extends StatelessWidget {
  const FoodTile(this.food, {required this.onDelete, super.key});

  final void Function() onDelete;
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
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FoodWidget(FoodIntent.add, food: food,))),
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
                    // icon: const Icon(Icons.more_vert_rounded),
                    onSelected: (value) async {
                      switch(value) {
                        case 0:
                          onDelete.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('delete'),
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
    required this.name,
    required this.amount,
    required this.unit,
    required this.kcal,
    required this.carbs,
    required this.proteins,
    required this.fats,
  });

  final String id;
  final String name;
  final Unit unit;
  final int amount;
  final int kcal;
  final int carbs;
  final int proteins;
  final int fats;

}