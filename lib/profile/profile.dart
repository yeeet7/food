
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:food/profile/settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Hi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white,),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            constraints: const BoxConstraints(maxWidth: 124),
            onSelected: (value) async {
              if(value == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
              } else if(value == 1) {
                await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                )
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.output_rounded, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    Text('Sign out', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                  ],
                )
              )
            ]
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            
            /// profile
            Row(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: MediaQuery.of(context).size.width * .25,
                  height: MediaQuery.of(context).size.width * .25,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(200)
                  ),
                  child: FirebaseAuth.instance.currentUser?.photoURL != null ? 
                    Image.network(FirebaseAuth.instance.currentUser!.photoURL!) :
                    Center(child: Text(FirebaseAuth.instance.currentUser?.displayName?[0] ?? '?')),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(FirebaseAuth.instance.currentUser?.displayName ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(FirebaseAuth.instance.currentUser?.email ?? '', style: const TextStyle(color: Colors.white54),),
                  ],
                )
              ],
            )

            /// TODO: BMI
            /// TODO: weight

          ],
        ),
      ),

    );
  }
}