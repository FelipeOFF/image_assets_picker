import 'dart:io';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class InstaAssetsExportDetails {
  /// The list of the cropped files
  final List<File> croppedFiles;

  /// The selected thumbnails, can provided to the picker to preselect those assets
  final List<AssetEntity> selectedAssets;

  /// The selected [aspectRatio] (1 or 4/5)
  final double aspectRatio;

  /// The [progress] param represents progress indicator between `0.0` and `1.0`.
  final double progress;

  const InstaAssetsExportDetails({
    required this.croppedFiles,
    required this.selectedAssets,
    required this.aspectRatio,
    required this.progress,
  });
}