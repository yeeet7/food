
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {

  final _ctrl = TextEditingController();
  final _node = FocusNode();

  @override
  void dispose() {
    _node.removeListener(() {});
    _ctrl.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ValueNotifier<bool> showTextFieldCancelButton = ValueNotifier(_node.hasFocus || _ctrl.text.isNotEmpty);
    final anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    showTextFieldCancelButton.addListener(() {log('showbutton: ${showTextFieldCancelButton.value}');});
    
    return Scaffold(

      body: CustomScrollView(

        slivers: [

          const CupertinoSliverNavigationBar(
            largeTitle: Text('test', style: TextStyle(color: Colors.white),),
            leading: CupertinoNavigationBarBackButton(color: Colors.white, previousPageTitle: 'Back',),
          ),
          SliverPersistentHeader(
            floating: false,
            pinned: true,
            delegate: SliverPersistentChildHeaderDelegate(
              height: 46,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 46,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(200),
                  ),
                ),
              ),
            )
          ),
          // SliverAppBar(
          //   automaticallyImplyLeading: false,
          //   pinned: true,
          //   toolbarHeight: 34,
          //   centerTitle: true,
          //   primary: false,
          //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(200),
          //   bottom: PreferredSize(preferredSize: const Size.fromHeight(46), child: Container()),
          //   actions: [
          //     AnimatedBuilder(
          //       animation: anim,
          //       builder: (context, child) {
          //         return Container(
          //           constraints: BoxConstraints(maxWidth: Tween(begin: 62, end: 0).animate(anim).value.toDouble()),
          //           child: CupertinoButton(
          //             color: Colors.transparent,
          //             padding: const EdgeInsets.only(right: 12),
          //             onPressed: () {_node.unfocus(); _ctrl.clear(); setState(() {});},
          //             child: Text(
          //               'Cancel',
          //               style: TextStyle(
          //                 color: ColorTween(begin: Theme.of(context).primaryColor, end: Theme.of(context).primaryColor.withOpacity(0))
          //                   .animate(anim).value
          //               ),
          //             ),
          //           ),
          //         );
          //       }
          //     )
          //   ],
          //   title: CupertinoTextField(
          //     placeholder: 'Search',
          //     controller: _ctrl,
          //     focusNode: _node,
          //     prefix: Icon(CupertinoIcons.search, color: Colors.grey.shade600,),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(6),
          //       color: const Color(0xFF222222),
          //     ),
          //   ),
          // ),

          SliverList.builder(itemBuilder: (context, index) => ListTile(leading: Text(index.toString()), tileColor: Colors.red,))

        ],

      ),

    );
  }
}

class SliverPersistentChildHeaderDelegate extends SliverPersistentHeaderDelegate {

  SliverPersistentChildHeaderDelegate({required this.child, this.height = 46});
  
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
  
}