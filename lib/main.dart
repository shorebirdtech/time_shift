import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'clocks/clock_face.dart';

/// Use this argument to choose a clock face. Defaults to particle if value is
/// provided or if the value provided is unrecognized.
///
/// Example:
/// `shorebird run -- --dart-define clock_face=generative`
const clockFaceArgName = 'clock_face';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  const clockName = String.fromEnvironment(clockFaceArgName);
  final clock = ClockFace.values.firstWhere(
    (clock) => clock.name == clockName,
    orElse: () => ClockFace.generative,
  );

  runApp(
    MaterialApp(
      home: clock.widget,
    ),
  );
}
