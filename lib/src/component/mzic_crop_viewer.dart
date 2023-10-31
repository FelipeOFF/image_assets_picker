import 'package:flutter/material.dart';
import 'package:mzic_image_assets_picker/src/controller/mzic_image_assets_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MzicCropViewer extends StatefulWidget {
  final MzicImageAssetsCropViewController? controller;
  final AssetEntity? assetEntity;

  const MzicCropViewer({
    super.key,
    this.controller,
    this.assetEntity,
  });

  @override
  State<MzicCropViewer> createState() => MzicCropViewerState();
}

class MzicCropViewerState extends State<MzicCropViewer> {
  MzicImageAssetsCropViewController get controller =>
      widget.controller ?? MzicImageAssetsCropViewControllerGeneric();

  @override
  void initState() {
    super.initState();
    if (controller is MzicImageAssetsCropViewControllerGeneric) {
      controller.previewAsset = widget.assetEntity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.previewAssetVN,
      builder: (context, assetSelected, _) {
        return Container();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
