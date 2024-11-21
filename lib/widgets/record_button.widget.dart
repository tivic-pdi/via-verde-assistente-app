import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class RecordButtonWidget extends StatefulWidget {
  final CameraController cameraController;
  double progress;

  RecordButtonWidget(
      {required this.cameraController, this.progress = 0, super.key});

  @override
  State<RecordButtonWidget> createState() => _RecordButtonWidgetState();
}

class _RecordButtonWidgetState extends State<RecordButtonWidget> {
  int totalSecs = 5;
  bool startRecording = false;

  @override
  Widget build(BuildContext context) {
    return Styled.widget(
        child: startRecording
            ? TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(seconds: totalSecs),
          builder: (context, value, _) =>
              CircularProgressIndicator(value: value),
        )
            : Container()) // red circle
        .decorated(
        color: Colors.red,
        border: Border.all(color: Colors.white, width: 5),
        borderRadius: BorderRadius.circular(50))
        .gestures(
      onTap: () {
        widget.cameraController.startVideoRecording();
        setState(() {
          startRecording = true;
        });

        Future.delayed(Duration(seconds: totalSecs + 1))
            .then((value) async {
          widget.cameraController.stopVideoRecording();

          setState(() {
            startRecording = false;
          });
        });
      },
    )
        .gestures(
      onTap: () {},
    )
        .positioned(height: 80, width: 80, bottom: 140);
  }
}
