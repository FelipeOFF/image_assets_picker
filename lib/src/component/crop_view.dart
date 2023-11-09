import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CropView extends StatelessWidget {
  final double aspectRatio;
  final double? height;
  final double? width;
  final AssetEntity asset;
  final GlobalKey<CropState> cropKey;
  final Color? backgroundColor;

  const CropView({
    super.key,
    this.aspectRatio = 1.0,
    this.height,
    this.width,
    required this.asset,
    required this.cropKey,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Crop(
        key: cropKey,
        alwaysShowGrid: true,
        isToDrawGrid: false,
        isToApplyBackgroundOpacity: false,
        isToDrawRectGrid: false,
        maximumScale: 10,
        aspectRatio: aspectRatio,
        disableResize: true,
        onLoading: (loading) {
          if (loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        backgroundColor: backgroundColor ?? Theme.of(context).canvasColor.withOpacity(0.5),
        image: AssetEntityImageProvider(asset, isOriginal: true),
        placeholderWidget: ExtendedImage(
          alignment: Alignment.center,
          height: height ?? MediaQuery.of(context).size.height,
          width: (width ?? MediaQuery.of(context).size.width) * aspectRatio,
          image: AssetEntityImageProvider(asset, isOriginal: true),
          filterQuality: FilterQuality.high,
          enableMemoryCache: false,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
