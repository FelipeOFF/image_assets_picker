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

  Future<bool> init() async {
    final cameras = await availableCameras();
    this.cameras = cameras;
    return true;
  }

  void toggleFlashState() {
    flashState = !flashState;
  }

  void toggleCamera() {
    camera = camera == frontCamera ? backCamera : frontCamera;
  }

  void dispose() {
    flashStateVN.dispose();
  }
}
