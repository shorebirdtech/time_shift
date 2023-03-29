import 'package:flutter/material.dart';
import 'package:time_shift/clocks/generative_clock/generative_clock.dart';
import 'package:time_shift/clocks/particle_clock/particle_clock.dart';

enum Clock {
  generative,
  particle,
}

extension ClockWidget on Clock {
  Widget get widget {
    switch (this) {
      case Clock.generative:
        return const GenerativeClock();
      case Clock.particle:
        return const ParticleClock();
    }
  }
}
