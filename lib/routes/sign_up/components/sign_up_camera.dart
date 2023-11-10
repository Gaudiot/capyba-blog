import 'package:camera/camera.dart';
import 'package:capyba_blog/shared/components/base_layout.dart';
import 'package:flutter/material.dart';

class SignUpCamera extends StatefulWidget {
  const SignUpCamera({super.key});

  @override
  State<SignUpCamera> createState() => _SignUpCameraState();
}

class _SignUpCameraState extends State<SignUpCamera> {
  Future<bool>? _isCameraInitialized;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _isCameraInitialized = initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<bool> initCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[1], 
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg
    );

    await _cameraController.initialize();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: FutureBuilder(
        future: _isCameraInitialized,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return _TakePhoto(cameraController: _cameraController);
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _TakePhoto extends StatelessWidget {
  const _TakePhoto({super.key, required this.cameraController});
  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CameraPreview(cameraController),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black
            ),
            child: Center(
              child: IconButton.outlined(onPressed: (){}, icon: const Icon(Icons.photo_camera), color: Colors.white),
              // child: GestureDetector(
              //   onTap: () async {
              //     final xFile = await cameraController.takePicture();
              //   },
              //   child: Container(
              //     height: 60,
              //     width: 60,
              //     decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.white
              //     ),
              //     child: const Icon(Icons.photo_camera_outlined, color: Colors.black),
              //   ),
              // )
            ),
          ),
        )
      ],
    );
  }
}