import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'clocks/clocks.dart';

/// Use this argument to choose a clock face. Defaults to particle.
///
/// Example:
/// `shorebird run -- --dart-define clock=generative`
const clockArgName = 'clock';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  const clockName = String.fromEnvironment(clockArgName);
  final clock = Clock.values.firstWhere(
    (clock) => clock.name == clockName,
    orElse: () => Clock.particle,
  );

  runApp(
    MaterialApp(
      home: clock.widget,
    ),
  );
}
