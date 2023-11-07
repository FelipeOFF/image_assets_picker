import 'package:flutter/material.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:image_assets_picker/src/model/assets_crop_data.dart';
import 'package:image_assets_picker/src/util/constants.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class BaseImageAssetsController {
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
    _dispose();
  }

  void _dispose() {}
}

class ImageAssetsController extends BaseImageAssetsController with ImageAssetsCropViewController {}

class ImageAssetsCropViewControllerGeneric extends BaseImageAssetsController
    with ImageAssetsCropViewController {}

mixin ImageAssetsCropViewController on BaseImageAssetsController {
  final ValueNotifier<AssetEntity?> previewAssetVN = ValueNotifier<AssetEntity?>(null);
  final ValueNotifier<bool> isLoadingErrorVM = ValueNotifier<bool>(false);
  final ValueNotifier<List<AssetsCropData>> listOfAssetsCropVM = ValueNotifier<List<AssetsCropData>>([]);
  final ValueNotifier<List<double>> cropRatiosVM = ValueNotifier<List<double>>(kCropRatios);
  final ValueNotifier<int> cropRatioIndexVM = ValueNotifier<int>(0);

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
    listOfAssetsCrop = selectedAssets.map((selectedAsset) {
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
  }

  void nextCropRatio() {
    if (cropRatioIndex < cropRatios.length - 1) {
      cropRatioIndex = cropRatioIndex + 1;
    } else {
      cropRatioIndex = 0;
    }
  }

  @override
  void _dispose() {
    previewAssetVN.dispose();
    listOfAssetsCropVM.dispose();
    isLoadingErrorVM.dispose();
    cropRatiosVM.dispose();
    cropRatioIndexVM.dispose();
    super.dispose();
  }
}
