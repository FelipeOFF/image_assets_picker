import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_assets_picker/src/controller/image_assets_controller.dart';
import 'package:image_assets_picker/src/util/constants.dart';
import 'package:image_assets_picker/src/util/list_ext.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CropViewer extends StatefulWidget {
  final ImageAssetsCropViewController? controller;
  final AssetEntity? assetEntity;
  final Widget? loadingWidget;
  final Size? size;
  final double preferredSize;
  final List<double> cropRatios;
  final Widget? loaderWidget;
  final String loadFailedText;
  final ValueChanged<AssetEntity>? unSelectAsset;
  final Color? backgroundColor;

  const CropViewer({
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
    this.backgroundColor,
  });

  @override
  State<CropViewer> createState() => CropViewerState();
}

class CropViewerState extends State<CropViewer> {
  final _cropKey = GlobalKey<CropState>();

  ImageAssetsCropViewController get controller => widget.controller ?? ImageAssetsCropViewControllerGeneric();

  Widget get loadingWidget => Center(child: widget.loadingWidget ?? const CircularProgressIndicator());

  Size get size => widget.size ?? Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.45);

  Color get backgroundColor => widget.backgroundColor ?? Theme.of(context).canvasColor;

  @override
  void initState() {
    super.initState();
    controller.init();
    controller.cropRatios = widget.cropRatios;
    if (controller is ImageAssetsCropViewControllerGeneric && widget.assetEntity != null) {
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
    return Consumer<DefaultAssetPickerProvider>(
      builder: (context, provider, child) {
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

                  final selectedAsset = selected.safeElementAt(effectiveIndex);
                  final asset = selectedAsset ?? previewAsset;

                  if (previewAsset == null && selected.isEmpty && asset == null) {
                    return loadingWidget;
                  }

                  final savedCropParam = widget.controller?.getAssetsCropByAssetEntity(asset!)?.cropParam;

                  if (asset != _previousAsset && _previousAsset != null) {
                    saveCurrentCropChanges(selected);
                  }

                  _previousAsset = asset;

                  if (selectedAsset == null && previewAsset != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      provider.selectAsset(previewAsset);
                    });
                  }

                  return SizedBox.fromSize(
                    size: size,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Crop(
                            alwaysShowGrid: true,
                            key: _cropKey,
                            isToDrawGrid: false,
                            isToApplyBackgroundOpacity: false,
                            image: AssetEntityImageProvider(asset!, isOriginal: true),
                            placeholderWidget: ValueListenableBuilder<bool>(
                              valueListenable: controller.isLoadingErrorVM,
                              builder: (context, isLoadingError, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ExtendedImage(
                                      // to match crop alignment
                                      alignment:
                                          controller.aspectRatio == 1.0 ? Alignment.center : Alignment.bottomCenter,
                                      height: size.height,
                                      width: size.height * controller.aspectRatio,
                                      image: AssetEntityImageProvider(asset, isOriginal: false),
                                      enableMemoryCache: false,
                                      fit: BoxFit.cover,
                                    ),
                                    // show backdrop when image is loading or if an error occured
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.4)),
                                      ),
                                    ),
                                    isLoadingError
                                        ? widget.loaderWidget ?? Text(widget.loadFailedText)
                                        : const SizedBox.shrink(),
                                  ],
                                );
                              },
                            ),
                            // if the image could not be loaded (i.e unsupported format like RAW)
                            // unselect it and clear cache, also show the error widget
                            isToDrawRectGrid: false,
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
                            backgroundColor: backgroundColor.withOpacity(0.5),
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
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
