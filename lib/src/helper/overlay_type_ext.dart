import 'package:cropperx/cropperx.dart';
import 'package:image_assets_picker/src/model/crop_shape_overlay.dart';

extension OverlayTypeExt on OverlayType {
  CropShapeOverlay? get cropShapeOverlay {
    switch (this) {
      case OverlayType.circle:
        return CropShapeOverlay.circle;
      case OverlayType.rectangle:
        return CropShapeOverlay.rectangle;
      default:
        return null;
    }
  }
}

extension CropShapeOverlayExt on CropShapeOverlay {
  OverlayType get overlayType {
    switch (this) {
      case CropShapeOverlay.circle:
        return OverlayType.circle;
      case CropShapeOverlay.rectangle:
        return OverlayType.rectangle;
    }
  }
}