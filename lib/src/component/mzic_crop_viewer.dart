import 'package:flutter/material.dart';
import 'package:mzic_image_assets_picker/src/controller/mzic_image_assets_controller.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MzicCropViewer extends StatefulWidget {
  final MzicImageAssetsCropViewController? controller;
  final AssetEntity? assetEntity;
  final Widget? loadingWidget;

  const MzicCropViewer({
    super.key,
    this.controller,
    this.assetEntity,
    this.loadingWidget,
  });

  @override
  State<MzicCropViewer> createState() => MzicCropViewerState();
}

class MzicCropViewerState extends State<MzicCropViewer> {
  MzicImageAssetsCropViewController get controller => widget.controller ?? MzicImageAssetsCropViewControllerGeneric();

  Widget get loadingWidget => widget.loadingWidget ?? const CircularProgressIndicator();

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
      builder: (context, assetSelected, _) => Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
        builder: (BuildContext context, List<AssetEntity> value, Widget? child) {
          if (assetSelected == null) {
            return loadingWidget;
          }

          return Container();
        },
        selector: (BuildContext context, DefaultAssetPickerProvider defaultAssetPickerProvider) =>
            defaultAssetPickerProvider.selectedAssets,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
