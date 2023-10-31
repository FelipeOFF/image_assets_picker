import 'package:flutter/material.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:mzic_image_assets_picker/src/model/mzic_assets_crop_data.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class BaseMzicImageAssetsController {
  void dispose() {}
}

class MzicImageAssetsController extends BaseMzicImageAssetsController with MzicImageAssetsCropViewController {}

class MzicImageAssetsCropViewControllerGeneric extends BaseMzicImageAssetsController
    with MzicImageAssetsCropViewController {}

mixin MzicImageAssetsCropViewController on BaseMzicImageAssetsController {
  final ValueNotifier<AssetEntity?> previewAssetVN = ValueNotifier<AssetEntity?>(null);
  final ValueNotifier<List<MzicAssetsCropData>> listOfAssetsCropVM = ValueNotifier<List<MzicAssetsCropData>>([]);

  AssetEntity? get previewAsset => previewAssetVN.value;

  set previewAsset(AssetEntity? value) => previewAssetVN.value = value;

  List<MzicAssetsCropData> get listOfAssetsCrop => listOfAssetsCropVM.value;

  set listOfAssetsCrop(List<MzicAssetsCropData> value) => listOfAssetsCropVM.value = value;

  MzicAssetsCropData? getAssetsCropByAssetEntity(AssetEntity asset) {
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
        return MzicAssetsCropData.fromState(
          asset: saveAsset,
          cropParam: cropParam,
          scale: scale,
          area: area,
        );
      } else if (savedCropAsset == null) {
        return MzicAssetsCropData.fromState(
          asset: selectedAsset,
        );
      } else {
        return savedCropAsset;
      }
    }).toList();
  }

  @override
  void dispose() {
    previewAssetVN.dispose();
    listOfAssetsCropVM.dispose();
    super.dispose();
  }
}
