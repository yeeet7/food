
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final multiplierCtrl = TextEditingController();
final multiplierNode = FocusNode();

class Food extends StatefulWidget {
  const Food(this.canAdd, {super.key});
  final bool canAdd;

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {

  Unit unit = Unit.gram;

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
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Column(
                            children: [
                              Text(index == 0 ? '30g' : index == 1 ? '30g' : index == 2 ? '30g' : '30g', style: TextStyle(color: index == 0 ? Colors.orange : index == 1 ? Theme.of(context).primaryColor : index == 2 ? Colors.blue.shade700 : Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 18),),
                              Text(index == 0 ? 'Calories' : index == 1 ? 'Carbs' : index == 2 ? 'Proteins' : 'Fats', style: const TextStyle(color: Colors.white30, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        )
                      )
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48 - 24) / 2,
                    child: TextField(
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
                      ),
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 48 - 24) / 2,
                    height: 55,
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
                      onChanged: (value) => setState(() {
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
              )
        
            ],
          ),
        ),
      ),

      floatingActionButton: widget.canAdd ? FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).primaryColor,),
        label: Text('add', style: TextStyle(color: Theme.of(context).primaryColor),),
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