import 'dart:io';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';

class CropView extends StatelessWidget {
  final double aspectRatio;
  final double? height;
  final double? width;
  final File image;
  final GlobalKey cropKey;
  final Color? backgroundColor;
  final int rotationTurns;

  const CropView({
    super.key,
    this.aspectRatio = 1.0,
    this.height,
    this.width,
    required this.cropKey,
    this.backgroundColor,
    required this.image,
    this.rotationTurns = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Cropper(
      cropperKey: cropKey,
      aspectRatio: aspectRatio,
      overlayType: OverlayType.circle,
      zoomScale: 1.0,
      overlayColor: backgroundColor ?? Theme.of(context).canvasColor.withOpacity(0.5),
      image: Image.file(image),
      rotationTurns: rotationTurns,
    );
  }
}
