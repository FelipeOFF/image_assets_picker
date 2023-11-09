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

  bool get flashState => flashStateVN.value;
  set flashState(bool value) => flashStateVN.value = value;

  List<CameraDescription> get cameras => camerasVN.value;
  set cameras(List<CameraDescription> value) => camerasVN.value = value;

  Future<void> init() async {
    final cameras = await availableCameras();
    this.cameras = cameras;
  }

  void toggleFlashState() {
    flashState = !flashState;
  }

  void dispose() {
    flashStateVN.dispose();
  }

}