
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/main.dart';
import 'package:food/widgets/test.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(200),
            leading: CupertinoNavigationBarBackButton(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, previousPageTitle: 'Back',onPressed: () => Navigator.pop(context),),
            largeTitle: Text('Settings', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _getChildren(context).length,
                (context, index) => _getChildren(context)[index],
              ),
            ),
          ),
        ]
      )
    );
  }
}

List<Widget> _getChildren(BuildContext context) => [
  //* account values section
  Material(
    borderRadius: BorderRadius.circular(12),
    color: Theme.of(context).colorScheme.secondary,
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const TestPage()));},
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: MediaQuery.of(context).size.width * 0.125,
                  height: MediaQuery.of(context).size.width * 0.125,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: FirebaseAuth.instance.currentUser?.photoURL != null ? 
                    Image.network(FirebaseAuth.instance.currentUser!.photoURL!, fit: BoxFit.cover,) :
                    Center(child: Text(FirebaseAuth.instance.currentUser?.displayName ?? ['?'][0])),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(FirebaseAuth.instance.currentUser?.displayName ?? '', style: const TextStyle(fontSize: 18),),
                    Text(FirebaseAuth.instance.currentUser?.email ?? '', style: const TextStyle(fontSize: 14, color: Color(0xFF7F7F7F)),),
                  ],
                )
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF7F7F7F),)
          ],
        ),
      ),
    ),
  ),

  const SizedBox(height: 12),
  
  //* units
  DefaultBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Units', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        SettingsButton(title: 'Weight', icon: FontAwesomeIcons.weightHanging, value: 'kg', values: WeightUnit.values.map((e) => e.name).toSet(), onTap: () {}), //* kg / lb
        Container(height: 1.5, width: MediaQuery.of(context).size.width - 48, color: Theme.of(context).colorScheme.tertiary,),
        SettingsButton(title: 'height', icon: FontAwesomeIcons.ruler, value: 'cm', values: HeightUnit.values.map((e) => e.name).toSet(), onTap: () {}), //* cm / in
        Container(height: 1.5, width: MediaQuery.of(context).size.width - 48, color: Theme.of(context).colorScheme.tertiary,),
        SettingsButton(title: 'volume', icon: FontAwesomeIcons.flask, value: 'ml', values: VolumeUnit.values.map((e) => e.name).toSet(), onTap: () {}), //* ml / fl.oz.
      ],
    ),
  ),

  const SizedBox(height: 12),
  
  //* Account section
  DefaultBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        SettingsButton(title: 'Sign out', icon: FontAwesomeIcons.arrowRightToBracket, color: CupertinoColors.destructiveRed, onTap: () {Navigator.pop(context); Navigator.pop(context); googleSignIn.signOut(); FirebaseAuth.instance.signOut();}),
        Container(height: 1.5, width: MediaQuery.of(context).size.width - 48, color: Theme.of(context).colorScheme.tertiary,),
        SettingsButton(title: 'Delete account', icon: FontAwesomeIcons.arrowRightToBracket, color: CupertinoColors.destructiveRed, onTap: () {}),
      ],
    ),
  ),
];

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    required this.title,
    this.icon,
    this.value,
    this.values,
    this.color,
    this.bgColor = Colors.transparent,
    this.onTap,
    super.key,
  }) : assert(value != null ? values != null : true);

  final String title;
  final IconData? icon;
  final dynamic value;
  final Set<dynamic>? values;
  final Color? color;
  final Color? bgColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: value == null ? onTap : () {Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsChoice(title: title, values: values!,)));},
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(icon != null) const SizedBox(width: 12),
                  if(icon != null) Icon(icon, color: color,),
                  const SizedBox(width: 12),
                  Text(title, style: TextStyle(fontSize: 16, color: color))
                ],
              ),
              if (value != null) Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(value.toString(), style: const TextStyle(color: Color(0xFF7F7F7F)),),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF7F7F7F),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsChoice extends StatefulWidget {
  const SettingsChoice({required this.title, required this.values, super.key});

  final String title;
  final Set<dynamic> values;

  @override
  State<SettingsChoice> createState() => _SettingsChoiceState();
}

class _SettingsChoiceState extends State<SettingsChoice> {
  @override
  Widget build(BuildContext context) {

    List<Widget> options = [];
    for (var e in widget.values) {
      options.add(SettingsButton(title: e.toString(), onTap: () {}));
      options.add(Container(height: 1.5, width: MediaQuery.of(context).size.width - 48, color: Theme.of(context).colorScheme.tertiary,));
    }
    options.removeLast();

    return Scaffold(

      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(200),
        leading: CupertinoNavigationBarBackButton(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, previousPageTitle: 'Back',onPressed: () => Navigator.pop(context),),
        middle: Text(widget.title, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
      ),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          DefaultBox(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options
            ),
          ),
        ]
      ),

    );
  }
}