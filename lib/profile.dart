
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CupertinoButton(
        child: const Text('sign out'),
        onPressed: () async {
          await googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
        },
      ),

    );
  }
}