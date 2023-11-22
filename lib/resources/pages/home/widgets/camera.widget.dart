import 'dart:developer';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:camera/camera.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:guia_digital/resources/pages/home/widgets/record_button.widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path_provider/path_provider.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({super.key});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController controller;
  List<CameraDescription>? cameras;
  bool _isReady = false;

  Future<void> _setupCameras() async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      controller = new CameraController(cameras![0], ResolutionPreset.high);
      await controller.initialize();
    } on CameraException catch (e) {
      log("CameraException: ${e.description}");
    }
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _setupCameras();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) return new Container();

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        CameraPreview(controller),
        Styled.widget(
                child: MapboxMap(
                    styleString: "mapbox://styles/mapbox/streets-v11",
                    accessToken:
                        "sk.eyJ1IjoiY29kc2lnbmVyIiwiYSI6ImNsb3o0enFkdTBhMGkyam1zMTV3ZDh1dTEifQ.VTY609k7l7tyyyL1kZS9yA",
                    initialCameraPosition: CameraPosition(
                        zoom: 14, target: LatLng(-14.8648, -40.8369))))
            .clipRRect(all: 10)
            .padding(all: 10)
            .height(125)
            .width(double.infinity)
            .backgroundColor(Colors.black54)
            .positioned(bottom: 0, left: 0, right: 0),
        RecordButtonWidget(cameraController: controller),
      ],
    );
  }
}
