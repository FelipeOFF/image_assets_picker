import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_assets_picker/src/model/assets_export_details.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:image_assets_picker/src/model/assets_crop_data.dart';
import 'package:image_assets_picker/src/util/constants.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class BaseImageAssetsController {

  final ValueNotifier<List<AssetsCropData>> listOfAssetsCropVM = ValueNotifier<List<AssetsCropData>>([]);
  final ValueNotifier<AssetEntity?> previewAssetVN = ValueNotifier<AssetEntity?>(null);
  final ValueNotifier<bool> isLoadingErrorVM = ValueNotifier<bool>(false);
  final ValueNotifier<List<double>> cropRatiosVM = ValueNotifier<List<double>>(kCropRatios);
  final ValueNotifier<int> cropRatioIndexVM = ValueNotifier<int>(0);
  final ValueNotifier<double> preferredSizeVM = ValueNotifier<double>(kPreferredCropSize);

  bool isInit = false;
  bool isDisposed = false;

  // Do not override this method
  void init() {
    if (isInit) return;
    isInit = true;
    _init();
  }

  void _init() {}

  // Do not override this method
  void dispose() {
    if (isDisposed) return;
    isDisposed = true;
    listOfAssetsCropVM.dispose();
    previewAssetVN.dispose();
    isLoadingErrorVM.dispose();
    cropRatiosVM.dispose();
    cropRatioIndexVM.dispose();
    _dispose();
  }

  void _dispose() {}
}

class ImageAssetsController extends BaseImageAssetsController with ImageAssetsCropViewController {

  static ImageAssetsController? _instance;

  factory ImageAssetsController() {
    _instance ??= ImageAssetsController._internal();
    return _instance!;
  }

  ImageAssetsController._internal();

  @override
  void _dispose() {
    _instance = null;
    super._dispose();
  }
}

class ImageAssetsCropViewControllerGeneric extends BaseImageAssetsController with ImageAssetsCropViewController {


  static ImageAssetsCropViewControllerGeneric? _instance;

  factory ImageAssetsCropViewControllerGeneric() {
    _instance ??= ImageAssetsCropViewControllerGeneric._internal();
    return _instance!;
  }

  ImageAssetsCropViewControllerGeneric._internal();

  @override
  void _dispose() {
    _instance = null;
    super._dispose();
  }
}

mixin ImageAssetsCropViewController on BaseImageAssetsController {

  AssetEntity? get previewAsset => previewAssetVN.value;
  set previewAsset(AssetEntity? value) => previewAssetVN.value = value;

  List<AssetsCropData> get listOfAssetsCrop => listOfAssetsCropVM.value;
  set listOfAssetsCrop(List<AssetsCropData> value) => listOfAssetsCropVM.value = value;

  bool get isLoadingError => isLoadingErrorVM.value;
  set isLoadingError(bool value) => isLoadingErrorVM.value = value;

  List<double> get cropRatios => cropRatiosVM.value;
  set cropRatios(List<double> value) => cropRatiosVM.value = value;

  int get cropRatioIndex => cropRatioIndexVM.value;
  set cropRatioIndex(int value) => cropRatioIndexVM.value = value;

  double get aspectRatio => cropRatios[cropRatioIndex];
  set aspectRatio(double value) => cropRatioIndex = cropRatios.indexOf(value);

  double get preferredSize => preferredSizeVM.value;
  set preferredSize(double value) => preferredSizeVM.value = value;

  AssetsCropData? getAssetsCropByAssetEntity(AssetEntity asset) {
    if (listOfAssetsCrop.isEmpty) return null;
    final index = listOfAssetsCrop.indexWhere((e) => e.asset == asset);
    if (index == -1) return null;
    return listOfAssetsCrop[index];
  }

  void onChange(
    AssetEntity? saveAsset,
    List<AssetEntity> selectedAssets, {
    CropInternal? cropParam,
    double scale = 1.0,
    Rect? area,
  }) {
    final listOfAssetsCrop = selectedAssets.map((selectedAsset) {
      final savedCropAsset = getAssetsCropByAssetEntity(selectedAsset);

      if (selectedAsset == saveAsset && saveAsset != null) {
        return AssetsCropData.fromState(
          asset: saveAsset,
          cropParam: cropParam,
          scale: scale,
          area: area,
        );
      } else if (savedCropAsset == null) {
        return AssetsCropData.fromState(
          asset: selectedAsset,
        );
      } else {
        return savedCropAsset;
      }
    }).toList();
    this.listOfAssetsCrop = listOfAssetsCrop;
  }

  void nextCropRatio() {
    if (cropRatioIndex < cropRatios.length - 1) {
      cropRatioIndex = cropRatioIndex + 1;
    } else {
      cropRatioIndex = 0;
    }
  }

  /// Apply all the crop parameters to the list of [selectedAssets]
  /// and returns the exportation as a [Stream]
  Stream<InstaAssetsExportDetails> exportCropFiles() async* {
    List<File> croppedFiles = [];

    /// Returns the [InstaAssetsExportDetails] with given progress value [p]
    InstaAssetsExportDetails makeDetail(double p) => InstaAssetsExportDetails(
          croppedFiles: croppedFiles,
          selectedAssets: listOfAssetsCrop.map((e) => e.asset).toList(),
          aspectRatio: aspectRatio,
          progress: p,
        );

    // start progress
    yield makeDetail(0);
    final list = listOfAssetsCrop;

    final step = 1 / list.length;

    for (var i = 0; i < list.length; i++) {
      final file = await list[i].asset.originFile;

      final scale = list[i].scale;
      final area = list[i].area;

      if (file == null) {
        throw 'error file is null';
      }

      // makes the sample file to not be too small
      final sampledFile = await InstaAssetsCrop.sampleImage(
        file: file,
        preferredSize: (preferredSize / scale).round(),
      );

      if (area == null) {
        croppedFiles.add(sampledFile);
      } else {
        // crop the file with the area selected
        final croppedFile = await InstaAssetsCrop.cropImage(file: sampledFile, area: area);
        // delete the not needed sample file
        sampledFile.delete();

        croppedFiles.add(croppedFile);
      }

      // increase progress
      yield makeDetail((i + 1) * step);
    }
    // complete progress
    yield makeDetail(1);
  }
}
