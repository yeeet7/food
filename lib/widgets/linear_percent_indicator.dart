
import 'package:flutter/material.dart';

class LinearPercentIndicator extends StatelessWidget {
  const LinearPercentIndicator(this.value, this.width, {this.animate = true, this.animationController, this.inside, this.height, this.bgColor, this.fgColor, super.key}) : assert(animate ? animationController != null : true);
  final double value;
  final double width;
  final double? height;
  final Color? fgColor;
  final Color? bgColor;
  final Widget? inside;
  final bool animate;
  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {

    late Widget returnWidget;
    if(animate) {
      returnWidget = Container(
        width: width,
        height: height ?? 14,
        decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12)
        ),
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: animationController!,
          builder: (context, child) {
            return Container(
              width: Tween(begin: 0.0, end: width*value).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeInOut)).value,
              height: height ?? 14,
              decoration: BoxDecoration(
                color: fgColor ?? Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12)
              ),
              child: FittedBox(child: inside)
            );
          }
        ),
      );
    } else {
      returnWidget = Container(
        width: width,
        height: height ?? 14,
        decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12)
        ),
        alignment: Alignment.centerLeft,
        child: Container(
          width: width*value,
          height: height ?? 14,
          decoration: BoxDecoration(
            color: fgColor ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12)
          ),
          child: FittedBox(child: inside)
        ),
      );
    }

    return returnWidget;
  }
}