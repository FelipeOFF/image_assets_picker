import 'dart:ui';

import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetsCropData {
  final AssetEntity asset;
  final CropInternal? cropParam;

  final double scale;
  final Rect? area;

  const AssetsCropData({
    required this.asset,
    required this.cropParam,
    this.scale = 1.0,
    this.area,
  });

  static AssetsCropData fromState({
    required AssetEntity asset,
    CropInternal? cropParam,
    double scale = 1.0,
    Rect? area,
  }) {
    return AssetsCropData(
      asset: asset,
      cropParam: cropParam,
      scale: scale,
      area: area,
    );
  }
}
