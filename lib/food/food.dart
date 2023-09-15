
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Food extends StatefulWidget {
  const Food(this.intent, {super.key});
  final FoodIntent intent;

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {

  Unit unit = Unit.gram;
  final multiplierCtrl = TextEditingController.fromValue(const TextEditingValue(text: '1'));
  final nameCtrl = TextEditingController();
  final kcalCtrl = TextEditingController.fromValue(const TextEditingValue(text: '1'));
  final carbsCtrl = TextEditingController.fromValue(const TextEditingValue(text: '1'));
  final proteinsCtrl = TextEditingController.fromValue(const TextEditingValue(text: '1'));
  final fatsCtrl = TextEditingController.fromValue(const TextEditingValue(text: '1'));

  final multiplierNode = FocusNode();
  final nameNode = FocusNode();
  final kcalNode = FocusNode();
  final carbsNode = FocusNode();
  final proteinsNode = FocusNode();
  final fatsNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Icon(FontAwesomeIcons.appleWhole, size: MediaQuery.of(context).size.width * .2, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    child: {FoodIntent.view, FoodIntent.add}.contains(widget.intent) ? Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Column(
                            children: [
                              Text(index == 0 ? '30' : index == 1 ? '30g' : index == 2 ? '30g' : '30g', style: TextStyle(color: index == 0 ? Colors.orange : index == 1 ? Theme.of(context).primaryColor : index == 2 ? Colors.blue.shade700 : Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 18),),
                              Text(index == 0 ? 'Calories' : index == 1 ? 'Carbs' : index == 2 ? 'Proteins' : 'Fats', style: const TextStyle(color: Colors.white30, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        )
                      )
                    ) : Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List.generate(
                        3,
                        (index) => SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: IconButton(
                            icon: Icon(index == 0 ? FontAwesomeIcons.cameraRetro : index == 1 ? FontAwesomeIcons.image : FontAwesomeIcons.trash, color: Colors.white38),
                            onPressed: () {}
                          ),
                        )
                      )
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if({FoodIntent.edit, FoodIntent.create}.contains(widget.intent)) Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48 - 24) / 2,
                    child:  TextField(
                      enabled: {FoodIntent.edit, FoodIntent.create}.contains(widget.intent),
                      onTapOutside: (event) => nameNode.unfocus(),
                      controller: nameCtrl,
                      focusNode: nameNode,
                      cursorColor: Colors.white70,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent)
                        ),
                        disabledBorder: OutlineInputBorder(
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
                    child: const Text('Name'),
                  )
                ],
              ),

              if ({FoodIntent.edit, FoodIntent.create}.contains(widget.intent)) const SizedBox(height: 12),

              if ({FoodIntent.edit, FoodIntent.create}.contains(widget.intent)) const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nutrition information per:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white30),),
                ],
              ),

              if (!{FoodIntent.edit, FoodIntent.create}.contains(widget.intent)) const FittedBox(
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white70
                  ),
                )
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48 - 24) / 2,
                    child: TextField(
                      enabled: widget.intent != FoodIntent.view,
                      onTapOutside: (event) {
                        if(multiplierNode.hasFocus && unit == Unit.portion) {
                          multiplierCtrl.text = '${multiplierCtrl.text.replaceAll('x', '') == '' ? '1' : multiplierCtrl.text}x';
                        }
                        multiplierNode.unfocus();
                      },
                      onSubmitted: (value) {
                        if(multiplierNode.hasFocus && unit == Unit.portion) {
                          multiplierCtrl.text = '${multiplierCtrl.text.replaceAll('x', '') == '' ? '1' : multiplierCtrl.text}x';
                        }
                        multiplierNode.unfocus();
                      },
                      onTap: () {multiplierNode.requestFocus(); if(unit == Unit.portion) multiplierCtrl.text = multiplierCtrl.text.replaceAll('x', '');},
                      controller: multiplierCtrl,
                      focusNode: multiplierNode,
                      cursorColor: Colors.white70,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent)
                        ),
                        disabledBorder: OutlineInputBorder(
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
                    child: DropdownButtonFormField(
                      value: unit.index,
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Theme.of(context).colorScheme.secondary,
                      icon: Transform.rotate(angle: pi*-.5, child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16,)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical:4),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent, width: 0)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent, width: 0)
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('grams')),
                        DropdownMenuItem(value: 1, child: Text('milliliters')),
                        DropdownMenuItem(value: 2, child: Text('portions')),
                      ],
                      onChanged: {FoodIntent.view, FoodIntent.add}.contains(widget.intent) ? null : (value) => setState(() {
                        unit = Unit.values.elementAt(value as int);
                        if(unit == Unit.portion) {
                          multiplierCtrl.text = '${multiplierCtrl.text.replaceAll('x', '') == '' ? '1' : multiplierCtrl.text.replaceAll('x', '')}x';
                        } else {
                          multiplierCtrl.text = multiplierCtrl.text.replaceAll('x', '');
                        }
                      })
                    ),
                  )
                ],
              ),

              if({FoodIntent.create, FoodIntent.edit}.contains(widget.intent)) ...List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 48 - 24) / 2,
                        child: TextField(
                          onTapOutside: (event) => multiplierNode.unfocus(),
                          controller: [kcalCtrl, carbsCtrl, proteinsCtrl, fatsCtrl][index],
                          focusNode: [kcalNode, carbsNode, proteinsNode, fatsNode][index],
                          cursorColor: Colors.white70,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            suffix: Text(['kcal', 'g', 'g', 'g'][index], style: const TextStyle(color: Colors.white30),),
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
                        child: Text(['Calories', 'Carbohydrates', 'Proteins', 'Fats'][index]),
                      )
                    ],
                  ),
                )
              )
        
            ],
          ),
        ),
      ),

      floatingActionButton: widget.intent != FoodIntent.view ? FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).primaryColor,),
        label: Text(widget.intent == FoodIntent.add ? 'add' : widget.intent == FoodIntent.edit ? 'save' : 'create', style: TextStyle(color: Theme.of(context).primaryColor),),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {}
      ) : null,

    );
  }
}

enum Unit {
  gram,
  milliliter,
  portion,
}
enum FoodIntent {
  view,
  add,
  create,
  edit,
}