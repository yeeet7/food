
import 'package:flutter/material.dart';

class AddFood extends StatelessWidget {
  const AddFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'FAB',
      child: Scaffold(
    
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
    
        body: const Column()
    
      ),
    );
  }
}