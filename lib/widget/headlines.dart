import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadLines extends ImplicitlyAnimatedWidget {
  final String title;
  final int index;

  Color get targetColor => index == 0 ? Colors.redAccent : Colors.white;

  HeadLines({this.title, this.index})
      : super(duration: const Duration(milliseconds: 600));

  @override
  _HeadLinesState createState() => _HeadLinesState();
}

class _HeadLinesState extends AnimatedWidgetBaseState<HeadLines> {
  _GhostColorTween _colorTween;
  _SwitchStringTween _switchStringTween;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${_switchStringTween.evaluate(animation)}",
      style: TextStyle(color: _colorTween.evaluate(animation)),
    );
  }

  @override
  void forEachTween(visitor) {
    _colorTween = visitor(
        _colorTween, widget.targetColor, (color) => _GhostColorTween(begin: color));
    _switchStringTween = visitor(
        _switchStringTween, widget.title, (value) => _SwitchStringTween(begin: value));
  }
}

class _GhostColorTween extends Tween<Color> {
  _GhostColorTween({Color begin, Color end}) : super();
  final Color middle = Colors.white70;

  Color lerp(double t) {
    if (t < 0.5) {
      return Color.lerp(begin, middle, t * 0.2);
    } else {
      return Color.lerp(middle, end, (t - 0.5) * 2);
    }
  }
}

class _SwitchStringTween extends Tween<String> {
  _SwitchStringTween({String begin, String end}) : super(begin: begin, end: end);

  String lerp(double t) {
    if (t < 0.5) return begin;
    return end;
  }
}
