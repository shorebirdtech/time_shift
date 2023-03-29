import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_shift/clocks/particle_clock/particle_clock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    const MaterialApp(
      home: ParticleClock(),
    ),
  );
}
