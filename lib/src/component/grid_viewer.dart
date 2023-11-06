import 'package:flutter/material.dart';
import 'package:image_assets_picker/src/controller/image_assets_controller.dart';
import 'package:image_assets_picker/src/util/list_ext.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class GridViewer extends StatelessWidget {
  final Widget? loadingWidget;
  final WidgetBuilder? failedItemBuilder;
  final int maxAssets;
  final MzicImageAssetsController controller;

  const GridViewer({
    super.key,
    this.loadingWidget,
    this.failedItemBuilder,
    this.maxAssets = 1,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DefaultAssetPickerProvider>(builder: (context, provider, _) {
      return Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
        selector: (BuildContext context, DefaultAssetPickerProvider defaultAssetPickerProvider) =>
            defaultAssetPickerProvider.selectedAssets,
        builder: (context, selected, _) => Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
          selector: (_, DefaultAssetPickerProvider p) => p.currentAssets,
          builder: (context, List<AssetEntity> assets, _) =>
              Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
            selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
            builder: (context, PathWrapper<AssetPathEntity>? wrapper, _) {
              final int totalCount = wrapper?.assetCount ?? 0;
              if (totalCount == 0) {
                return loadingWidget ?? const SizedBox.shrink();
              }
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: totalCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  mainAxisExtent: 97,
                ),
                itemBuilder: (context, index) {
                  final AssetEntity? asset = assets.safeElementAt(index);
                  final isSelected = selected.contains(asset);
                  if (asset == null) {
                    return const SizedBox.shrink();
                  }
                  final AssetEntityImageProvider imageProvider = AssetEntityImageProvider(
                    asset,
                    isOriginal: false,
                    thumbnailSize: const ThumbnailSize.square(97),
                  );
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: AssetEntityGridItemBuilder(
                            image: imageProvider,
                            failedItemBuilder: failedItemBuilder ?? (_) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      _buildSelectWidget(selected, isSelected, context, provider, asset),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }

  Positioned _buildSelectWidget(List<AssetEntity> selected, bool isSelected, BuildContext context,
      DefaultAssetPickerProvider provider, AssetEntity asset) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          if (maxAssets != 1 && selected.length == maxAssets && !isSelected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("You can only select $maxAssets images"),
              ),
            );
            return;
          }
          if (isSelected && selected.length > 1) {
            provider.unSelectAsset(asset);
          }
          if (isSelected && selected.length == 1) {
            provider.unSelectAsset(asset);
            controller.previewAsset = null;
          }
          if (maxAssets == 1) {
            for (final AssetEntity selectedAsset in selected) {
              provider.unSelectAsset(selectedAsset);
            }
            provider.selectAsset(asset);
            controller.previewAsset = asset;
          } else {
            provider.selectAsset(asset);
          }
        },
        child: Consumer<DefaultAssetPickerProvider>(
          builder: (_, provider, __) {
            final int index = provider.selectedAssets.indexOf(asset);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(.45)
                  : Theme.of(context).colorScheme.background.withOpacity(.1),
              child: const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
