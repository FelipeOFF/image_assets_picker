import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:mzic_image_assets_picker/src/controller/mzic_image_assets_controller.dart';
import 'package:mzic_image_assets_picker/src/util/constants.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MzicCropViewer extends StatefulWidget {
  final MzicImageAssetsCropViewController? controller;
  final AssetEntity? assetEntity;
  final Widget? loadingWidget;
  final Size? size;
  final double preferredSize;
  final List<double> cropRatios;
  final Widget? loaderWidget;
  final String loadFailedText;
  final ValueChanged<AssetEntity>? unSelectAsset;

  const MzicCropViewer({
    super.key,
    this.controller,
    this.assetEntity,
    this.loadingWidget,
    this.size,
    this.preferredSize = kPreferredCropSize,
    this.cropRatios = kCropRatios,
    this.loadFailedText = "Load failed",
    this.loaderWidget,
    this.unSelectAsset,
  });

  @override
  State<MzicCropViewer> createState() => MzicCropViewerState();
}

class MzicCropViewerState extends State<MzicCropViewer> {
  final _cropKey = GlobalKey<CropState>();

  MzicImageAssetsCropViewController get controller => widget.controller ?? MzicImageAssetsCropViewControllerGeneric();

  Widget get loadingWidget => Center(child: widget.loadingWidget ?? const CircularProgressIndicator());

  Size get size => widget.size ?? Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.3);

  @override
  void initState() {
    super.initState();
    controller.init();
    controller.cropRatios = widget.cropRatios;
    if (controller is MzicImageAssetsCropViewControllerGeneric && widget.assetEntity != null) {
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
    return Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
      builder: (context, currentPath, _) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          final list = await currentPath?.path.getAssetListRange(start: 0, end: 1);
          if (list?.isNotEmpty == true) {
            controller.previewAsset = list?.first;
          }
        });

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

              return SizedBox.fromSize(
                size: size,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Crop(
                        key: _cropKey,
                        image: AssetEntityImageProvider(asset, isOriginal: true),
                        placeholderWidget: ValueListenableBuilder<bool>(
                          valueListenable: controller.isLoadingErrorVM,
                          builder: (context, isLoadingError, child) => Stack(
                            alignment: Alignment.center,
                            children: [
                              ExtendedImage(
                                // to match crop alignment
                                alignment: controller.aspectRatio == 1.0 ? Alignment.center : Alignment.bottomCenter,
                                height: size.height,
                                width: size.height * controller.aspectRatio,
                                image: AssetEntityImageProvider(asset, isOriginal: false),
                                enableMemoryCache: false,
                                fit: BoxFit.cover,
                              ),
                              // show backdrop when image is loading or if an error occured
                              isLoadingError
                                  ? Text(widget.loadFailedText)
                                  : (widget.loaderWidget ?? const SizedBox.shrink()),
                            ],
                          ),
                        ),
                        // if the image could not be loaded (i.e unsupported format like RAW)
                        // unselect it and clear cache, also show the error widget
                        onImageError: (exception, stackTrace) {
                          widget.unSelectAsset?.call(asset);
                          AssetEntityImageProvider(asset).evict();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.isLoadingError = true;
                          });
                        },
                        maximumScale: 10,
                        aspectRatio: controller.aspectRatio,
                        disableResize: true,
                        backgroundColor: Theme.of(context).canvasColor,
                        initialParam: savedCropParam,
                      ),
                    ),
                  ],
                ),
              );
            },
            selector: (BuildContext context, DefaultAssetPickerProvider defaultAssetPickerProvider) =>
                defaultAssetPickerProvider.selectedAssets,
          ),
        );
      },
      selector: (BuildContext context, DefaultAssetPickerProvider defaultAssetPickerProvider) {
        return defaultAssetPickerProvider.currentPath;
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}