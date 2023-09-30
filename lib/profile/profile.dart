
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
            ),

            /// TODO: BMI
            DefaultBox(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Body Mass Index (BMI)', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 6,),
                  Text('${(userInfo.weight / (userInfo.height * userInfo.height) * 100000).round() / 10}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  /// arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: remap(15, 40, (userInfo.weight / (userInfo.height * userInfo.height) * 100000).round() / 10, 0, MediaQuery.of(context).size.width - 48) - 1 - (25/2)),
                      const SizedBox(
                        width: 25,
                        child: Icon(Icons.keyboard_arrow_down_rounded),
                      )
                    ],
                  ),
                  /// chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...List.generate(
                        5,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: remap(
                                0,
                                25,
                                [3.5, 6.5, 5, 5, 5][index],
                                0,
                                MediaQuery.of(context).size.width - 48
                              ) - 1,
                              height: 12,
                              decoration: BoxDecoration(
                                color: [const Color(0xFF28b6f6), const Color(0xFF66bb6a), const Color(0xFFffc928), const Color(0xFFff7143), const Color(0xFFee534f)][index],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            index < 4 ?
                              Text(['15', '18.5', '25', '30'][index], style: const TextStyle(fontWeight: FontWeight.bold),):
                              SizedBox(
                                width: remap(0, 25, 5, 0, MediaQuery.of(context).size.width - 48) - 1,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('35', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text('40', style: TextStyle(fontWeight: FontWeight.bold),),
                                  ]
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            /// TODO: weight

          ],
        ),
      ),

    );
  }
}