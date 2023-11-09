import 'package:flutter/cupertino.dart';

class CameraAssetPickerController {

  static CameraAssetPickerController? _instance;

  factory CameraAssetPickerController() {
    _instance ??= CameraAssetPickerController._internal();
    return _instance!;
  }

  CameraAssetPickerController._internal();

  final ValueNotifier<bool> flashStateVN = ValueNotifier<bool>(false);

  bool get flashState => flashStateVN.value;
  set flashState(bool value) => flashStateVN.value = value;

  void toggleFlashState() {
    flashState = !flashState;
  }

  void dispose() {
    flashStateVN.dispose();
  }

}