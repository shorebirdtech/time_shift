import 'package:flutter/material.dart';
import 'package:time_shift/clocks/generative_clock/generative_clock.dart';
import 'package:time_shift/clocks/particle_clock/particle_clock.dart';

import 'cloom_clock/digital_clock.dart';

/// All available clock faces.
enum ClockFace {
  cloom,
  generative,
  particle,
}

extension ClockFaceWidget on ClockFace {
  /// Builds the clock face widget associated with this [ClockFace].
  Widget get widget {
    switch (this) {
      case ClockFace.cloom:
        return const DigitalClock();
      case ClockFace.generative:
        return const GenerativeClock();
      case ClockFace.particle:
        return const ParticleClock();
    }
  }
}
