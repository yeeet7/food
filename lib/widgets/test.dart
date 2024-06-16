
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      body: PageView.builder(
        itemBuilder:(context, index) => [
          CustomScrollView(
          
            slivers: [
          
              const CupertinoSliverNavigationBar(
                largeTitle: Text('test', style: TextStyle(color: Colors.white),),
                leading: CupertinoNavigationBarBackButton(color: Colors.white, previousPageTitle: 'Back',),
                border: null,
              ),
              const CupertinoAppBarBottom(),
          
              SliverList.builder(itemBuilder: (context, index) => ListTile(leading: Text(index.toString()), tileColor: Colors.red,))
          
            ],
          
          ),
          
          SuperScaffold(
            appBar: SuperAppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(200),
              leading: CupertinoNavigationBarBackButton(previousPageTitle: 'Back',color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, onPressed: () => Navigator.pop(context),),
              title: const Text('test', style: TextStyle(color: Colors.white)),
              largeTitle: SuperLargeTitle(largeTitle: 'test'),
              border: null,
            ),

            body: ListView.builder(itemBuilder: (context, index) => ListTile(leading: Text(index.toString()), tileColor: Colors.red,)),

          )

        ][index%2],
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

class CupertinoAppBarBottom extends StatefulWidget {
  const CupertinoAppBarBottom({super.key});

  @override
  State<CupertinoAppBarBottom> createState() => _CupertinoAppBarBottomState();
}

class _CupertinoAppBarBottomState extends State<CupertinoAppBarBottom> {

  final _ctrl = TextEditingController();
  final _node = FocusNode();
  bool _scrolledUnder = false;
  ScrollNotificationObserverState? _scrollNotificationObserver;

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final bool oldScrolledUnder = _scrolledUnder;
      final ScrollMetrics metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          _scrolledUnder = metrics.extentAfter > 0;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
        case AxisDirection.right:
        case AxisDirection.left:
          // Scrolled under is only supported in the vertical axis, and should
          // not be altered based on horizontal notifications of the same
          // predicate since it could be a 2D scroller.
          break;
      }

      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {});
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_scrollNotificationObserver != null) {
      _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    }
    _scrollNotificationObserver = ScrollNotificationObserver.of(context);
    if(_scrollNotificationObserver != null) {
      _scrollNotificationObserver?.addListener(_handleScrollNotification);
    }
  }

  @override
  void dispose() {
    _node.removeListener(() {});
    _ctrl.removeListener(() {});
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: false,
      pinned: true,
      delegate: SliverPersistentChildHeaderDelegate(
        height: 46,
        child: SizedBox(
          height: 46,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: DecoratedBox(
                position: DecorationPosition.background,
                decoration: BoxDecoration(
                  gradient: _scrolledUnder ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0,1],
                    colors: [
                      Theme.of(context).appBarTheme.backgroundColor!.withAlpha(240),
                      Theme.of(context).appBarTheme.backgroundColor!.withAlpha(230),
                    ]
                  ):null,
                  color: Theme.of(context).appBarTheme.backgroundColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 62 - 24,
                      child: CupertinoTextField(
                        placeholder: 'Search',
                        controller: _ctrl,
                        focusNode: _node,
                        prefix: Icon(CupertinoIcons.search, color: Colors.grey.shade600,),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF222222),
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 62),//BoxConstraints(maxWidth: Tween(begin: 62, end: 0).animate(anim).value.toDouble()),
                      child: CupertinoButton(
                        color: null,
                        padding: EdgeInsets.zero,
                        onPressed: () {_node.unfocus(); _ctrl.clear(); setState(() {});},
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            // color: ColorTween(begin: Theme.of(context).primaryColor, end: Theme.of(context).primaryColor.withOpacity(0))
                            //   .animate(anim).value
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}