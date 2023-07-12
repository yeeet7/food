
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:macros/main.dart';

final emailCtrl = TextEditingController();
final passwordCtrl = TextEditingController();

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: 'email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)
                  )
                ),
              ),
            ),
            const SizedBox(height: 12,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: passwordCtrl,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)
                  )
                ),
              ),
            ),
            const SizedBox(height: 12,),
            Button(
              const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              width: MediaQuery.of(context).size.width * 0.8,
              onTap: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailCtrl.text.trim(), password: passwordCtrl.text.trim());
                } catch(e) {
                  if(e.toString().split(']').first.split('/').last == 'email-already-in-use') {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailCtrl.text.trim(), password: passwordCtrl.text.trim());
                    } catch(el) {
                      if(el.toString().split(']').first.split('/').last == 'wrong-password') {
                        log('wrong password');
                      }
                    }
                  }
                  
                }
              },
            ),
            const SizedBox(height: 12,),
            Button(
              const Icon(FontAwesomeIcons.google),
              width: 40,
              onTap: () async {
                GoogleSignInAccount? account = await googleSignIn.signIn();
                GoogleSignInAuthentication auth = await account!.authentication;
                await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken));
              }
            ),
          ],
        ),
      ),

    );
  }
}

class Button extends StatelessWidget {
  const Button(this.child, {this.onTap, required this.width, super.key});
  final Widget child;
  final double width;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).primaryColor,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}