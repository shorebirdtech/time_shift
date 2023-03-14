import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'palette.dart';
import 'scene.dart';

class ParticleClock extends StatefulWidget {
  const ParticleClock({super.key});

  @override
  State<ParticleClock> createState() => _ParticleClockState();
}

class _ParticleClockState extends State<ParticleClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer? _timer;
  double seek = 0.0;
  double seekIncrement = 1 / 3600;

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

  Future<List<Palette>> _loadPalettes() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/palettes.json");
    var palettes = json.decode(data) as List;
    return palettes.map((p) => Palette.fromJson(p)).toList();
  }

  void _updateModel() {
    // Cause the clock to rebuild when the model changes.
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        const Duration(seconds: 1) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FutureBuilder(
        future: _loadPalettes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              child: Center(
                child: Text("Could not load palettes."),
              ),
            );
          }

          List<Palette>? palettes = snapshot.data;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Scene(
                size: constraints.biggest,
                palettes: palettes,
                time: _dateTime,
                brightness: Theme.of(context).brightness,
              );
            },
          );
        },
      ),
    );
  }
}
