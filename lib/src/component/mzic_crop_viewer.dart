import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
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
  final _cropKey = GlobalKey<CropState>();

  MzicImageAssetsCropViewController get controller => widget.controller ?? MzicImageAssetsCropViewControllerGeneric();

  Widget get loadingWidget => Center(child: widget.loadingWidget ?? const CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    controller.init();
    if (controller is MzicImageAssetsCropViewControllerGeneric) {
      controller.previewAsset = widget.assetEntity;
    }
  }

  AssetEntity? _previousAsset;

  void saveCurrentCropChanges(List<AssetEntity> selectedAssets) {
    controller.onChange(
      _previousAsset,
      selectedAssets,
      area: _cropKey.currentState?.area,
      cropParam: _cropKey.currentState?.internalParameters,
      scale: _cropKey.currentState?.scale ?? 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.previewAssetVN,
      builder: (context, previewAsset, _) => Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
        builder: (BuildContext context, List<AssetEntity> selected, Widget? child) {
          final int effectiveIndex = selected.isEmpty ? 0 : selected.indexOf(selected.last);

          if (previewAsset == null && selected.isEmpty) {
            return loadingWidget;
          }

          final asset = previewAsset ?? selected[effectiveIndex];
          final savedCropParam = widget.controller?.getAssetsCropByAssetEntity(asset)?.cropParam;

          if (asset != _previousAsset && _previousAsset != null) {
            saveCurrentCropChanges(selected);
          }

          _previousAsset = asset;

          return Stack(
            children: [
              Positioned.fill(
                child: Crop(
                  key: _cropKey,
                  alwaysShowGrid: true,
                  aspectRatio: 1,
                  backgroundColor: Colors.black,
                  image: AssetEntityImageProvider(
                    asset,
                    isOriginal: true,
                  ),
                ),
              ),
            ],
          );
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
