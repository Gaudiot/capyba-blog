import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/shared/components/base_layout.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';

class SignUpCamera extends StatefulWidget {
  const SignUpCamera({super.key, required this.user});

  final UserDTO user;

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
              return _TakePhoto(cameraController: _cameraController, user: widget.user);
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _TakePhoto extends StatelessWidget {
  const _TakePhoto({super.key, required this.cameraController, required this.user});

  final UserDTO user;
  final CameraController cameraController;

  Future<bool> checkFaceInImage(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast
    );
    final faceDetector = FaceDetector(options: options);
    final faces = await faceDetector.processImage(inputImage);

    return faces.isNotEmpty;
  }

  void _takePicture(BuildContext context) async {
    final fileImage = await cameraController.takePicture();
    final imageHaveFace = await checkFaceInImage(fileImage.path);

    debugPrint("Foto tirada");
    if(imageHaveFace){
      debugPrint("Rosto identificado com sucesso");
      final IFirebaseService firebaseService = FirebaseService();
      final newUser = await firebaseService.signUp(user);
      debugPrint("User created: ${newUser?.email}");
      if(context.mounted){
        context.goNamed('home');
      }
    }else{
      debugPrint("Rosto NÃO foi encontrado");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CameraPreview(cameraController),
          ]
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.photo_camera), 
                color: Colors.white,
                onPressed: () => _takePicture(context)
              ),
            ),
          ),
        )
      ],
    );
  }
}