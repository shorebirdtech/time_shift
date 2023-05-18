// Copyright 2020 Filipe Barroso. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:time_shift/clocks/cloom_clock/flare/assets_utils/numbers_assets.dart';
import 'package:time_shift/clocks/cloom_clock/flare/number_flare_controller.dart';

class SwitchNumbers extends StatelessWidget {
  final FlareControllerEntry number;
  final double height;
  final double width;

  const SwitchNumbers({
    super.key,
    required this.number,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            FlareActor(
              number.previous?.asset,
              controller:
                  NumberFlareControler(currentState: AnimationState.hide),
            ),
            FlareActor(
              number.asset,
              controller:
                  NumberFlareControler(currentState: AnimationState.show),
            )
          ],
        ));
  }
}
