import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({super.key});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController controller;
  List<CameraDescription>? cameras;
  bool _isReady = false;
  bool _isRecording = false;

  // Localização fixa do usuário.
  static const LatLng _userPosition = LatLng(-14.8579, -40.8284);

  final MapController _mapController = MapController();

  Future<void> _setupCameras() async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        log("Nenhuma câmera disponível no dispositivo.");
        return;
      }

      final backCamera = cameras!.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras!.first,
      );

      controller = CameraController(backCamera, ResolutionPreset.high);
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
  void dispose() {
    if (_isReady) controller.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (!_isReady) return;
    try {
      if (_isRecording) {
        final video = await controller.stopVideoRecording();
        setState(() => _isRecording = false);
        final videoFile = File(video.path);
        await DocumentFileSavePlus().saveFile(
          videoFile.readAsBytesSync(),
          "video.mp4",
          "video/mp4",
        );
        log("Vídeo salvo em: ${video.path}");
      } else {
        await controller.startVideoRecording();
        setState(() => _isRecording = true);
      }
    } on CameraException catch (e) {
      log("Erro ao gravar: ${e.description}");
      if (mounted) setState(() => _isRecording = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        CameraPreview(controller),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 125,
                child: _MiniMap(
                  mapController: _mapController,
                  position: _userPosition,
                  onRecenter: () => _mapController.move(_userPosition, 16),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          child: _RecordButton(
            isRecording: _isRecording,
            onTap: _toggleRecording,
          ),
        ),
      ],
    );
  }
}

class _MiniMap extends StatelessWidget {
  final MapController mapController;
  final LatLng position;
  final VoidCallback onRecenter;

  const _MiniMap({
    required this.mapController,
    required this.position,
    required this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: position,
            initialZoom: 16,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.via_verde_assistente.guia_digital',
              maxZoom: 19,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: position,
                  width: 44,
                  height: 44,
                  child: const _UserMarker(),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: InkWell(
              onTap: onRecenter,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.my_location_rounded,
                    size: 18, color: Color(0xFF16A34A)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserMarker extends StatelessWidget {
  const _UserMarker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16A34A).withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;

  const _RecordButton({required this.isRecording, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isRecording ? 'Parar gravação' : 'Iniciar gravação',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.white, width: 5),
            borderRadius: BorderRadius.circular(isRecording ? 14 : 50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
