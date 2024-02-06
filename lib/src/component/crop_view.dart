import 'dart:io';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';

class CropView extends StatelessWidget {
  final double aspectRatio;
  final File image;
  final GlobalKey cropKey;
  final Color? backgroundColor;
  final int rotationTurns;
  final OverlayType overlayType;

  const CropView({
    super.key,
    this.aspectRatio = 1.0,
    required this.cropKey,
    this.backgroundColor,
    required this.image,
    this.rotationTurns = 0,
    this.overlayType = OverlayType.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Cropper(
      cropperKey: cropKey,
      aspectRatio: aspectRatio,
      overlayType: overlayType,
      zoomScale: 1.0,
      overlayColor: backgroundColor ?? Theme.of(context).canvasColor.withOpacity(0.5),
      image: Image.file(image),
      rotationTurns: rotationTurns,
    );
  }
}
