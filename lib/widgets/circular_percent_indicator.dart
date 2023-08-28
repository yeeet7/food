
import 'dart:math';
import 'package:flutter/material.dart';

@immutable
class CircularPercentIndicator extends StatefulWidget {
  const CircularPercentIndicator(this.value, {this.shouldAnimate = false, this.animationController, this.center, this.strokeWidth, this.bgColor, this.fgColor, super.key}):assert(shouldAnimate == true ? (animationController != null):true);
  final double value;
  final AnimationController? animationController;
  final bool shouldAnimate;
  final Widget? center; 
  final double? strokeWidth;
  final Color? bgColor;
  final Color? fgColor;

  @override
  State<CircularPercentIndicator> createState() => _CircularPercentIndicatorState();
}

class _CircularPercentIndicatorState extends State<CircularPercentIndicator> {
  @override
  Widget build(BuildContext context) {

    Widget returnWidget;
    if(widget.shouldAnimate) {
      returnWidget = AnimatedBuilder(
        animation: widget.animationController!,
        builder: (context, child) {
          return CustomPaint(
            isComplex: false,
            foregroundPainter: _CircularPercentIndicatorPainter(
              Tween(begin: 0.0, end: widget.value).animate(widget.animationController!).value,
              bgColor: widget.bgColor,
              fgColor: widget.fgColor,
              strokeWidth: widget.strokeWidth,
            ),
            child: Center(child: widget.center),
          );
        }
      );
    } else {
      returnWidget = CustomPaint(
        isComplex: false,
        foregroundPainter: _CircularPercentIndicatorPainter(
          widget.value,
          bgColor: widget.bgColor,
          fgColor: widget.fgColor,
          strokeWidth: widget.strokeWidth,
        ),
        child: Center(child: widget.center),
      );
    }
    return returnWidget;
  }
}

@immutable
class _CircularPercentIndicatorPainter extends CustomPainter {

  const _CircularPercentIndicatorPainter(this.value, {this.strokeWidth, this.bgColor, this.fgColor});
  final double value; 
  final double? strokeWidth;
  final Color? bgColor;
  final Color? fgColor;

  @override
  void paint(Canvas canvas, Size size) {
    /// configure paint for background
    Paint bg = Paint()..strokeWidth = strokeWidth ?? 10
      ..color = bgColor ?? Colors.grey
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = 40;
    /// draw background    
    canvas.drawCircle(center, radius, bg);

    /// configure paint for foreground
    Paint fg = Paint()
      ..strokeWidth = strokeWidth ?? 10
      ..color = fgColor ?? Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    /// draw the percentage circle
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 1.5*pi, 2*pi*value, false, fg);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}