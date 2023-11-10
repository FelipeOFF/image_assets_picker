import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraAssetPickerController {
  static CameraAssetPickerController? _instance;

  factory CameraAssetPickerController() {
    _instance ??= CameraAssetPickerController._internal();
    return _instance!;
  }

  CameraAssetPickerController._internal();

  final ValueNotifier<bool> flashStateVN = ValueNotifier<bool>(false);
  final ValueNotifier<List<CameraDescription>> camerasVN = ValueNotifier<List<CameraDescription>>([]);
  late final ValueNotifier<CameraDescription> cameraVN = ValueNotifier<CameraDescription>(frontCamera);
  final ValueNotifier<XFile?> imageVN = ValueNotifier<XFile?>(null);
  final ValueNotifier<File?> croppedFileVN = ValueNotifier<File?>(null);
  final ValueNotifier<bool> isLoadingCroppedFileVN = ValueNotifier<bool>(false);
  final ValueNotifier<int> rotationTurnsVN = ValueNotifier<int>(0);

  bool get flashState => flashStateVN.value;

  set flashState(bool value) => flashStateVN.value = value;

  List<CameraDescription> get cameras => camerasVN.value;

  set cameras(List<CameraDescription> value) => camerasVN.value = value;

  CameraDescription get camera => cameraVN.value;

  set camera(CameraDescription value) => cameraVN.value = value;

  CameraDescription get frontCamera => cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

  CameraDescription get backCamera => cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

  XFile? get image => imageVN.value;

  set image(XFile? value) => imageVN.value = value;

  File? get cropedFile => croppedFileVN.value;

  set cropedFile(File? value) => croppedFileVN.value = value;

  bool get isLoadingCroppedFile => isLoadingCroppedFileVN.value;

  set isLoadingCroppedFile(bool value) => isLoadingCroppedFileVN.value = value;

  int get rotationTurns => rotationTurnsVN.value;
  set rotationTurns(int value) => rotationTurnsVN.value = value;

  Future<bool> init() async {
    cameras = await availableCameras();
    return true;
  }

  void toggleFlashState() {
    flashState = !flashState;
  }

  void toggleCamera() {
    camera = camera == frontCamera ? backCamera : frontCamera;
  }

  Future<void> saveFile() async {
    final image = this.image;
    if (image != null) {
      cropedFile = File(image.path);
    }
  }

  Future<void> saveCropedFile(
      Future<Uint8List?> image,
  ) async {
    isLoadingCroppedFile = true;
    try {
      final bytes = await image;
      if (bytes != null) {
        cropedFile = File.fromRawPath(bytes);
      }
    } finally {
      isLoadingCroppedFile = false;
    }
  }

  void dispose() {
    flashStateVN.dispose();
    camerasVN.dispose();
    cameraVN.dispose();
    imageVN.dispose();
    croppedFileVN.dispose();
    isLoadingCroppedFileVN.dispose();
  }
}
