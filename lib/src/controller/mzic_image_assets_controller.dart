import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class BaseMzicImageAssetsController {
  void dispose() {}
}

class MzicImageAssetsController extends BaseMzicImageAssetsController with MzicImageAssetsCropViewController {}

class MzicImageAssetsCropViewControllerGeneric extends BaseMzicImageAssetsController
    with MzicImageAssetsCropViewController {}

mixin MzicImageAssetsCropViewController on BaseMzicImageAssetsController {
  final ValueNotifier<AssetEntity?> previewAssetVN = ValueNotifier<AssetEntity?>(null);

  AssetEntity? get previewAsset => previewAssetVN.value;
  set previewAsset(AssetEntity? value) => previewAssetVN.value = value;

  @override
  void dispose() {
    previewAssetVN.dispose();
    super.dispose();
  }
}
