import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Note')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the future is complete, display the camera preview
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}