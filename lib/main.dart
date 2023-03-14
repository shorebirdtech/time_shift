import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import 'particle_clock.dart';

void main() {
  runApp(ClockCustomizer((ClockModel model) => ParticleClock(model)));
}
