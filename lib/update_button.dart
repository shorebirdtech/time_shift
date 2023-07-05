import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class UpdateButton extends StatefulWidget {
  const UpdateButton({super.key});

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

enum UpdateStatus {
  idle,
  checking,
  finishingCheck,
}

class _UpdateButtonState extends State<UpdateButton> {
  UpdateStatus status = UpdateStatus.idle;
  late bool _haveShorebirdEngine;
  bool _haveUpdate = false;
  final _shorebirdCodePush = ShorebirdCodePush();

  @override
  void initState() {
    super.initState();
    // TODO(eseidel): Remove after this is added to shorebird_code_push:
    // https://github.com/shorebirdtech/updater/issues/49
    final ffi.DynamicLibrary library = ffi.DynamicLibrary.process();
    _haveShorebirdEngine = library.providesSymbol('shorebird_update');
  }

  Future<bool> _doUpdateCheck() async {
    if (_haveShorebirdEngine) {
      // Ask the Shorebird servers if there is a new patch available.
      return _shorebirdCodePush.isNewPatchAvailableForDownload();
    } else {
      return Future.delayed(const Duration(seconds: 2), () => false);
    }
  }

  Future<void> _checkForUpdate() async {
    setState(() {
      status = UpdateStatus.checking;
    });
    final isUpdateAvailable = await _doUpdateCheck();

    if (!mounted) return;

    if (isUpdateAvailable) {
      await _shorebirdCodePush.downloadUpdateIfAvailable();
    }
    setState(() {
      _haveUpdate = isUpdateAvailable;
      status = UpdateStatus.finishingCheck;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        status = UpdateStatus.idle;
      });
    });
  }

  Widget widgetForStatus(UpdateStatus status) {
    switch (status) {
      case UpdateStatus.idle:
        if (_haveUpdate) {
          return const Icon(Icons.restart_alt);
        } else {
          // TODO(eseidel): Use a color so the rocket isn't blue, maybe a
          // partially tranparent gray instead?  Maybe get a color from the
          // current clock face?
          return const Icon(Icons.rocket);
        }
      case UpdateStatus.checking:
        return const SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      case UpdateStatus.finishingCheck:
        return const Icon(Icons.thumb_up_outlined);
    }
  }

  void Function()? actionForStatus(UpdateStatus status) {
    switch (status) {
      case UpdateStatus.idle:
        if (_haveUpdate) {
          return Restart.restartApp;
        } else {
          return _checkForUpdate;
        }
      case UpdateStatus.checking:
        return null;
      case UpdateStatus.finishingCheck:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final widget = widgetForStatus(status);
    final action = actionForStatus(status);

    return TextButton(
      onPressed: action,
      child: widget,
    );
  }
}
