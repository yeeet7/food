
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(225),
        leading: CupertinoNavigationBarBackButton(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, previousPageTitle: 'Back',onPressed: () => Navigator.pop(context),),
        middle: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            SizedBox(height: MediaQuery.of(context).padding.top + 56),

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