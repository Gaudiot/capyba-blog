import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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

    if(context.mounted){
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message: "Processing image, please wait."
        )
      );
    }

    if(imageHaveFace){
      try {
        final IFirebaseService firebaseService = FirebaseService();
        await firebaseService.signUp(user);
        await firebaseService.updateProfileImage(fileImage.path);
        if(context.mounted){
          context.goNamed('home');
        }
      } on FirebaseException catch (e) {
        if(context.mounted){
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: "A server error occured. The error is ${e.toString()}"
            )
          );
        }
      } catch (e) {
        if(context.mounted){
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: "An unknown error occured. The error is ${e.toString()}"
            )
          );
        }
      }
    }else{
      if(context.mounted){
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "No face was detected. Please, try again"
          )
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(cameraController),
            const _FaceMessage(),
            Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            )
          ]
        ),
        _BottomCamera(onPressed: () => _takePicture(context))
      ],
    );
  }
}

class _BottomCamera extends StatelessWidget {
  const _BottomCamera({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black
        ),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle
            ),
            child: IconButton(
              icon: const Icon(Icons.photo_camera), 
              color: Colors.white,
              iconSize: 50,
              onPressed: onPressed
            ),
          ),
        ),
      ),
    );
  }
}

class _FaceMessage extends StatelessWidget {
  const _FaceMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xff00e963)
        ),
        child: const Text("Center your face inside the circle", style: TextStyle(
          fontWeight: FontWeight.bold
        )),
      ),
    );
  }
}