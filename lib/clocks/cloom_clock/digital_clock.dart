// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:intl/intl.dart';
import 'package:time_shift/clocks/cloom_clock/widgets/animated_number.dart';

import 'colors.dart';
import 'flare/assets_utils/dots_assets.dart';
import 'flare/assets_utils/numbers_assets.dart';

class ThemeValues {
  ThemeValues({
    required this.textColor,
    required this.shadowColor,
    required this.gradient,
    required this.brightness,
  });

  final Color textColor;

  final Color shadowColor;

  final BoxDecoration gradient;

  final Brightness brightness;
}

final _lightTheme = ThemeValues(
  textColor: Colors.white,
  shadowColor: Colors.black,
  brightness: Brightness.light,
  gradient: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [cloomPrimaryLight, cloomSecondaryLight],
    ),
  ),
);

final _darkTheme = ThemeValues(
  textColor: Colors.white,
  shadowColor: const Color(0xFF174EA6),
  brightness: Brightness.dark,
  gradient: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [cloomPrimaryDark, cloomSecondaryDark],
    ),
  ),
);

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  final double numberWidth = 240;
  final double numberHeight = 350;

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer? _timer;
  FlareNumberAssets? _flareAssets;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _updateModel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        const Duration(seconds: 1) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeValues = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final assetsType =
        Theme.of(context).brightness == Brightness.light ? "light" : "dark";
    final assetDots = Theme.of(context).brightness == Brightness.light
        ? DotsAssets.light
        : DotsAssets.dark;

    _flareAssets = FlareNumberAssets(type: assetsType);

    // Get current time
    final hour =
        DateFormat(MediaQuery.of(context).alwaysUse24HourFormat ? 'HH' : 'hh')
            .format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    // Parse times to integers
    int hourTens = int.parse(hour[0]); // X0:00
    int hourOnes = int.parse(hour[1]); // 0X:00
    int minuteTens = int.parse(minute[0]); // 00:X0
    int minuteOnes = int.parse(minute[1]); // 0X:0X

    // Get current controllers for each number
    FlareControllerEntry hourTensController =
        _flareAssets!.getController(hourTens);
    FlareControllerEntry hourOnesController =
        _flareAssets!.getController(hourOnes);
    FlareControllerEntry minuteTensController =
        _flareAssets!.getController(minuteTens);
    FlareControllerEntry minuteOnesController =
        _flareAssets!.getController(minuteOnes);

    // Draw
    return Container(
      decoration: themeValues.gradient, // colors[_Element.gradient],
      child: Stack(
        clipBehavior: Clip.none,
        // overflow: Overflow.visible,
        children: <Widget>[
          // -- Hour
          Positioned(
            left: -10,
            child: SwitchNumbers(
              height: widget.numberHeight,
              width: widget.numberWidth,
              number: hourTensController,
            ),
          ),
          // -- Hour
          Positioned(
            left: 120,
            top: 40,
            child: SwitchNumbers(
              height: widget.numberHeight,
              width: widget.numberWidth,
              number: hourOnesController,
            ),
          ),
          Center(
            child: SizedBox(
              height: widget.numberHeight,
              width: widget.numberWidth,
              child: FlareActor(
                assetDots,
                animation: "loop",
              ),
            ),
          ),
          // -- Minutes
          Positioned(
            right: 120,
            child: SwitchNumbers(
              height: widget.numberHeight,
              width: widget.numberWidth,
              number: minuteTensController,
            ),
          ),
          // -- Minutes
          Positioned(
            right: -10,
            top: 40,
            child: SwitchNumbers(
              number: minuteOnesController,
              height: widget.numberHeight,
              width: widget.numberWidth,
            ),
          )
        ],
      ),
    );
  }
}
