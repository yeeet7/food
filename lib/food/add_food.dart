
import 'package:flutter/material.dart';
import 'package:food/food/new_food.dart';

class AddFood extends StatelessWidget {
  const AddFood({super.key});

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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewFood())),
            )
          ],
        ),
    
        body: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //TODO: show foods
              //TODO: filter by ssearch
            ],
          ),
        )
    
      ),
    );
  }
}