import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'clocks/clock_face.dart';

/// Use this argument to choose a clock face. Defaults to particle if value is
/// provided or if the value provided is unrecognized.
///
/// Example:
/// `shorebird run -- --dart-define clock_face=generative`
const clockFaceArgName = 'clock_face';

/// Use this argument to show the performance overlay.
///
/// Example:
/// `shorebird run -- --dart-define show_perf_overlay=true`
const showPerfOverlayArgName = 'show_perf_overlay';

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
      showPerformanceOverlay:
          const bool.fromEnvironment(showPerfOverlayArgName),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: clock.widget,
      ),
    ),
  );
}
