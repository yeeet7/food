
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text('Settings'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DefaultBox(
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.of(context).size.width * 0.125,
                    height: MediaQuery.of(context).size.width * 0.125,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(200)
                    ),
                    child: FirebaseAuth.instance.currentUser?.photoURL != null ? 
                      Image.network(FirebaseAuth.instance.currentUser!.photoURL!) :
                      Center(child: Text(FirebaseAuth.instance.currentUser?.displayName ?? ['?'][0])),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}