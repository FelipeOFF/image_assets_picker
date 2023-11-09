import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
  final ValueNotifier<AssetEntity?> assetVN = ValueNotifier<AssetEntity?>(null);
  final ValueNotifier<File?> croppedFileVN = ValueNotifier<File?>(null);
  final ValueNotifier<bool> isLoadingCroppedFileVN = ValueNotifier<bool>(false);

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

  AssetEntity? get asset => assetVN.value;

  set asset(AssetEntity? value) => assetVN.value = value;

  File? get cropedFile => croppedFileVN.value;

  set cropedFile(File? value) => croppedFileVN.value = value;

  bool get isLoadingCroppedFile => isLoadingCroppedFileVN.value;

  set isLoadingCroppedFile(bool value) => isLoadingCroppedFileVN.value = value;

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
      final imageTitle = _generateImageTitle();
      asset = await PhotoManager.editor.saveImageWithPath(image.path, title: imageTitle);
    }
  }

  String _generateImageTitle() {
    final now = DateTime.now();
    return "IMG_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
  }

  Future<void> saveCropedFile(
    double? scale,
    Rect? area,
  ) async {
    isLoadingCroppedFile = true;
    try {
      final file = await asset?.file;
      if (file != null && scale != null) {
        final sampleFile = await InstaAssetsCrop.sampleImage(
          file: file,
          preferredSize: scale.round(),
        );

        if (area == null) {
          cropedFile = sampleFile;
        } else {
          final croppedFile = await InstaAssetsCrop.cropImage(file: sampleFile, area: area);
          sampleFile.delete();
          cropedFile = croppedFile;
        }
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
    assetVN.dispose();
    croppedFileVN.dispose();
    isLoadingCroppedFileVN.dispose();
  }
}
