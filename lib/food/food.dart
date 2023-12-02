
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/widgets/food_tile.dart';
import 'package:image_picker/image_picker.dart';

class FoodWidget extends StatefulWidget {
  const FoodWidget(this.intent, this.setstate, {this.food, super.key});
  final FoodIntent intent;
  final void Function() setstate;
  final Food? food;

  @override
  State<FoodWidget> createState() => _FoodWidgetState();
}

class _FoodWidgetState extends State<FoodWidget> {

  String? tempImage;
  bool tempImageFile = false;

  late Unit unit;
  late final TextEditingController notesCtrl;
  late final TextEditingController multiplierCtrl;
  late final TextEditingController nameCtrl;
  late final TextEditingController kcalCtrl;
  late final TextEditingController carbsCtrl;
  late final TextEditingController proteinsCtrl;
  late final TextEditingController fatsCtrl;

  final notesNode = FocusNode();
  final multiplierNode = FocusNode();
  final nameNode = FocusNode();
  final kcalNode = FocusNode();
  final carbsNode = FocusNode();
  final proteinsNode = FocusNode();
  final fatsNode = FocusNode();

  @override
  void initState() {
    super.initState();
    unit = widget.food?.unit ?? Unit.gram;
    notesCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.food is FoodEntry ? (widget.food as FoodEntry).notes : widget.food?.notes ?? ''));
    multiplierCtrl = TextEditingController.fromValue(TextEditingValue(text: '${widget.food is FoodEntry ? (widget.food as FoodEntry).diaryAmount : widget.food?.amount ?? 1}${widget.food?.unit == Unit.portion ? 'x' : ''}'));
    nameCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.food?.name ?? 'name'));
    kcalCtrl = TextEditingController.fromValue(TextEditingValue(text: (widget.food?.kcal ?? '1').toString()));
    carbsCtrl = TextEditingController.fromValue(TextEditingValue(text: (widget.food?.carbs ?? '1').toString()));
    proteinsCtrl = TextEditingController.fromValue(TextEditingValue(text: (widget.food?.proteins ?? '1').toString()));
    fatsCtrl = TextEditingController.fromValue(TextEditingValue(text: (widget.food?.fats ?? '1').toString()));
    Future.delayed(Duration.zero, () async {
      String? image = widget.food?.imagePath != null ? (await FirebaseStorage.instance.ref(widget.food!.imagePath).getDownloadURL()):null;
      setState(() {tempImage = image; tempImageFile = false;});
    });
  }

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
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: () {
                      if({FoodIntent.create, FoodIntent.edit}.contains(widget.intent)) {
                        if(tempImage == null) return Icon(FontAwesomeIcons.appleWhole, size: MediaQuery.of(context).size.width * .2, color: Theme.of(context).primaryColor);
                        return tempImageFile ?
                          Image.file(File(tempImage!), fit: BoxFit.cover, height: MediaQuery.of(context).size.width * .4, width: MediaQuery.of(context).size.width * .4,):
                          Image.network(tempImage!, fit: BoxFit.cover, height: MediaQuery.of(context).size.width * .4, width: MediaQuery.of(context).size.width * .4,);
                      } else {
                        if(tempImage == null) return Icon(FontAwesomeIcons.appleWhole, size: MediaQuery.of(context).size.width * .2, color: Theme.of(context).primaryColor);
                        return Image.network(tempImage!, fit: BoxFit.cover, height: MediaQuery.of(context).size.width * .4, width: MediaQuery.of(context).size.width * .4);
                      }
                    }.call(),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    child: {FoodIntent.view, FoodIntent.add, FoodIntent.editInDiary}.contains(widget.intent) ? Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Column(
                            children: [
                              Text(index == 0 ? '${widget.food?.kcal ?? '0'}' : index == 1 ? '${widget.food?.carbs ?? 0}g' : index == 2 ? '${widget.food?.proteins ?? 0}g' : '${widget.food?.fats ?? 0}g', style: TextStyle(color: index == 0 ? Colors.orange : index == 1 ? Theme.of(context).primaryColor : index == 2 ? Colors.blue.shade700 : Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 18),),
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
                            onPressed: 
                              index == 0 ? () async {
                              tempImage = (await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 25))?.path;
                              setState(() {tempImageFile = true;});
                            } : index == 1 ? () async {
                              tempImage = (await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 25))?.path;
                              setState(() {tempImageFile = true;});
                            } : () => setState(() {tempImage = null; tempImageFile = true;})
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
                      enabled: true,
                      onTapOutside: (event) => nameNode.unfocus(),
                      controller: nameCtrl,
                      focusNode: nameNode,
                      cursorColor: Colors.white70,
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

              if (!{FoodIntent.edit, FoodIntent.create}.contains(widget.intent)) FittedBox(
                child: Text(
                  widget.food?.name ?? "name",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white70
                  ),
                )
              ),

              if({FoodIntent.view, FoodIntent.add, FoodIntent.editInDiary}.contains(widget.intent)) const SizedBox(height: 12),

              if({FoodIntent.view, FoodIntent.add, FoodIntent.editInDiary}.contains(widget.intent)) Row(
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
                    child: {FoodIntent.create, FoodIntent.edit}.contains(widget.intent) ? DropdownButtonFormField(
                      value: unit.index,
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Theme.of(context).colorScheme.secondary,
                      icon: Transform.rotate(angle: math.pi*-.5, child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16,)),
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
                    ) : Text(unit.name),
                  )
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: MediaQuery.of(context).size.width - 48 - 10,
                child: TextField(
                  enabled: !{FoodIntent.view, FoodIntent.add, FoodIntent.editInDiary}.contains(widget.intent),
                  onTapOutside: (event) => notesNode.unfocus(),
                  onSubmitted: (value) => notesNode.unfocus(),
                  onTap: () => notesNode.requestFocus(),
                  controller: notesCtrl,
                  focusNode: notesNode,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.center,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    label: const Center(child: Text('Notes', style: TextStyle(color: Colors.white),)),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    alignLabelWithHint: true,
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
            
              if ({FoodIntent.edit, FoodIntent.create}.contains(widget.intent)) const SizedBox(height: 12),

              if ({FoodIntent.edit, FoodIntent.create}.contains(widget.intent)) const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nutrition information per:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white30),),
                ],
              ),

              if(!{FoodIntent.view, FoodIntent.add, FoodIntent.editInDiary}.contains(widget.intent)) const SizedBox(height: 12),

              if(!{FoodIntent.view, FoodIntent.add, FoodIntent.editInDiary}.contains(widget.intent)) Row(
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
                    child: {FoodIntent.create, FoodIntent.edit}.contains(widget.intent) ? DropdownButtonFormField(
                      value: unit.index,
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Theme.of(context).colorScheme.secondary,
                      icon: Transform.rotate(angle: math.pi*-.5, child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16,)),
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
                    ) : Text(unit.name),
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
        label: Text(widget.intent == FoodIntent.add ? 'add' : {FoodIntent.edit, FoodIntent.editInDiary}.contains(widget.intent) ? 'save' : 'create', style: TextStyle(color: Theme.of(context).primaryColor),),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () async {
          switch(widget.intent) {
            case FoodIntent.create:
              FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).collection('foods').doc(DateTime.now().toString()).set({
                'name': nameCtrl.text,
                'amount': int.parse(multiplierCtrl.text.replaceAll('x', '')),
                'unit': unit.index,
                'imagePath': tempImage != null ? (await FirebaseStorage.instance.ref('${FirebaseAuth.instance.currentUser?.uid}/${widget.food?.id}').putFile(File(tempImage!)).then((p0) => p0.ref.fullPath)) : null,
                'notes': notesCtrl.text,
                'calories': int.tryParse(kcalCtrl.text) == null ? double.parse(kcalCtrl.text) : int.parse(kcalCtrl.text),
                'carbs': int.tryParse(carbsCtrl.text) == null ? double.parse(carbsCtrl.text) : int.parse(carbsCtrl.text),
                'proteins': int.tryParse(proteinsCtrl.text) == null ? double.parse(proteinsCtrl.text) : int.parse(proteinsCtrl.text),
                'fats': int.tryParse(fatsCtrl.text) == null ? double.parse(fatsCtrl.text) : int.parse(fatsCtrl.text),
              });
              widget.setstate.call();
              Navigator.pop(context);
              break;
            case FoodIntent.edit:
              if(tempImage == null && widget.food?.imagePath != null) await FirebaseStorage.instance.ref('${FirebaseAuth.instance.currentUser?.uid}/${widget.food?.id}').delete();
              FirebaseFirestore.instance.collection('config').doc(FirebaseAuth.instance.currentUser?.uid).collection('foods').doc(widget.food?.id).set({
                'name': nameCtrl.text,
                'amount': int.parse(multiplierCtrl.text.replaceAll('x', '')),
                'unit': unit.index,
                'imagePath': tempImageFile ? (tempImage != null ? (await FirebaseStorage.instance.ref('${FirebaseAuth.instance.currentUser?.uid}/${widget.food?.id}').putFile(File(tempImage!)).then((p0) => p0.ref.fullPath)) : null) : widget.food?.imagePath,
                'notes': notesCtrl.text,
                'calories': int.tryParse(kcalCtrl.text) == null ? double.parse(kcalCtrl.text) : int.parse(kcalCtrl.text),
                'carbs': int.tryParse(carbsCtrl.text) == null ? double.parse(carbsCtrl.text) : int.parse(carbsCtrl.text),
                'proteins': int.tryParse(proteinsCtrl.text) == null ? double.parse(proteinsCtrl.text) : int.parse(proteinsCtrl.text),
                'fats': int.tryParse(fatsCtrl.text) == null ? double.parse(fatsCtrl.text) : int.parse(fatsCtrl.text),
              }, SetOptions(merge: true));
              widget.setstate.call();
              Navigator.pop(context);
              break;
            case FoodIntent.add:
              FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}').set({
                DateTime.now().toString(): {
                  'id': widget.food?.id,
                  'amount': int.parse(multiplierCtrl.text.replaceAll('x', '')),
                }
              }, SetOptions(merge: true));
              widget.setstate.call();
              Navigator.pop(context);
              Navigator.pop(context);
              break;
            case FoodIntent.view:
              widget.setstate.call();
              break;
            case FoodIntent.editInDiary:
              FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}').set({
                ((widget.food as FoodEntry).diaryId): {
                  'amount': int.parse(multiplierCtrl.text.replaceAll('x', '')),
                }
              }, SetOptions(merge: true));
              widget.setstate.call();
              Navigator.pop(context);
              break;
          }
        }
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
  editInDiary,
}