import 'package:flutter/material.dart';
import 'package:image_assets_picker/src/controller/camera_asset_picker_controller.dart';

class CameraAssetPickerPage extends StatefulWidget {
  final CameraAssetPickerController? controller;

  // Header
  final Positioned? header;
  final EdgeInsets? headerPadding;

  // Header

  // Icons

  final double? topIconsSplashRadius;
  final double? topIconsSize;
  final double? topIconsCircularRadius;
  final EdgeInsets? topIconsInnerPadding;
  final BoxConstraints? topIconsConstraints;
  final ButtonStyle? topIconsStyle;
  final Color? topIconsBackgroundColor;
  final Color? topIconsColor;

  // Icons

  // Close button

  final Widget? closeButton;
  final Widget? iconClose;
  final VoidCallback? onPressedClose;

  // Close button

  // Flash button

  final Widget? flashButton;
  final Widget? flashIconOn;
  final Widget? flashIconOff;
  final VoidCallback? onPressedFlash;

  // Flash button

  // Rotate camera

  final Widget? rotateCameraButton;
  final Widget? rotateCameraIcon;
  final VoidCallback? onPressedRotateCamera;

  // Rotate camera

  // Circle button take picture

  final Widget? circleButtonTakePicture;
  final VoidCallback? onPressedTakePicture;
  final Color? circleButtonColor;
  final Color? circleButtonBorderColor;
  final double? circleButtonSize;
  final double? circleRadius;
  final double? circleStrokeWidth;
  final EdgeInsets? circleButtonPadding;

  // Circle button take picture

  const CameraAssetPickerPage({
    super.key,
    this.header,
    this.headerPadding,
    this.topIconsSplashRadius,
    this.topIconsSize,
    this.topIconsCircularRadius,
    this.topIconsInnerPadding,
    this.topIconsConstraints,
    this.topIconsStyle,
    this.topIconsBackgroundColor,
    this.topIconsColor,
    this.iconClose,
    this.onPressedClose,
    this.closeButton,
    this.flashButton,
    this.onPressedFlash,
    this.flashIconOn,
    this.flashIconOff,
    this.controller,
    this.rotateCameraButton,
    this.rotateCameraIcon,
    this.onPressedRotateCamera, this.circleButtonTakePicture, this.onPressedTakePicture, this.circleButtonColor, this.circleButtonBorderColor, this.circleButtonSize, this.circleStrokeWidth, this.circleRadius, this.circleButtonPadding,
  });

  @override
  State<CameraAssetPickerPage> createState() => _CameraAssetPickerPageState();
}

class _CameraAssetPickerPageState extends State<CameraAssetPickerPage> {
  CameraAssetPickerController get controller => widget.controller ?? CameraAssetPickerController();

  double get topIconsSplashRadius => widget.topIconsSplashRadius ?? 12;

  double get topIconsSize => widget.topIconsSize ?? 20;

  EdgeInsets get topIconsInnerPadding => widget.topIconsInnerPadding ?? const EdgeInsets.all(8);

  BoxConstraints get topIconsConstraints =>
      widget.topIconsConstraints ??
          const BoxConstraints(
            minWidth: 34,
            minHeight: 34,
          );

  double get topIconsCircularRadius => widget.topIconsCircularRadius ?? 12;

  Color get topIconsBackgroundColor => widget.topIconsBackgroundColor ?? const Color(0xFF999ABA).withOpacity(0.2);

  ButtonStyle get topIconsStyle =>
      widget.topIconsStyle ??
          ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(topIconsCircularRadius),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(topIconsBackgroundColor),
          );

  Color get topIconsColor => widget.topIconsColor ?? Colors.white;

  Widget _buildIcon({required Widget icon, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: onPressed,
      splashRadius: topIconsSplashRadius,
      iconSize: topIconsSize,
      padding: topIconsInnerPadding,
      constraints: topIconsConstraints,
      style: topIconsStyle,
      icon: icon,
    );
  }

  Widget get iconClose =>
      widget.iconClose ??
          Icon(
            Icons.close,
            color: topIconsColor,
          );

  Widget get iconFlashOn =>
      widget.flashIconOn ??
          Icon(
            Icons.flash_on,
            color: topIconsColor,
          );

  Widget get iconFlashOff =>
      widget.flashIconOff ??
          Icon(
            Icons.flash_off,
            color: topIconsColor,
          );

  Widget get rotateCameraIcon =>
      widget.rotateCameraIcon ??
          Icon(
            Icons.flip_camera_ios,
            color: topIconsColor,
          );

  VoidCallback get onPressedClose =>
      widget.onPressedClose ??
              () {
            Navigator.pop(context);
          };

  VoidCallback get onPressedFlash =>
      widget.onPressedFlash ??
              () {
            controller.toggleFlashState();
          };

  VoidCallback get onPressedRotateCamera =>
      widget.onPressedRotateCamera ??
              () {
            // TODO rotate camera
            // controller.toggleCameraLens();
          };

  VoidCallback get onPressedTakePicture =>
      widget.onPressedTakePicture ??
              () {
            // TODO take picture
            print("Take picture");
          };

  Widget get _buildCloseButton =>
      widget.closeButton ??
          _buildIcon(
            onPressed: onPressedClose,
            icon: iconClose,
          );

  Widget get _buildFlashButton =>
      widget.flashButton ??
          _buildIcon(
            onPressed: onPressedFlash,
            icon: ValueListenableBuilder(
              valueListenable: controller.flashStateVN,
              builder: (context, flashState, _) {
                return flashState == true ? iconFlashOn : iconFlashOff;
              },
            ),
          );

  Widget get _buildRotateCameraButton =>
      widget.rotateCameraButton ??
          _buildIcon(
            onPressed: onPressedRotateCamera,
            icon: rotateCameraIcon,
          );

  EdgeInsets get headerPadding =>
      widget.headerPadding ??
          const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 45,
          );

  Widget get _buildHeader =>
      widget.header ??
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: headerPadding,
              child: Row(
                children: [
                  _buildCloseButton,
                  const Spacer(),
                  _buildFlashButton,
                  const SizedBox(
                    width: 16,
                  ),
                  _buildRotateCameraButton,
                ],
              ),
            ),
          );

  Color get circleButtonColor => widget.circleButtonColor ?? const Color(0xFFD9D9D9).withOpacity(0.3);
  Color get circleButtonBorderColor => widget.circleButtonBorderColor ?? const Color(0xFFE6E6EA);

  double get circleButtonSize => widget.circleButtonSize ?? 72;
  double get circleStrokeWidth => widget.circleStrokeWidth ?? 3;
  double get circleRadius => widget.circleRadius ?? 36;

  EdgeInsets get circleButtonPadding => widget.circleButtonPadding ?? const EdgeInsets.only(bottom: 47.0);

  Widget get _buildElipsedBottomButton => widget.circleButtonTakePicture ??
      Positioned(
        right: 0,
        left: 0,
        bottom: 0,
        child: Padding(
          padding: circleButtonPadding,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressedTakePicture,
                borderRadius: BorderRadius.circular(circleRadius),
                splashColor: Colors.white.withOpacity(0.3),
                hoverColor: Colors.white.withOpacity(0.3),
                focusColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.3),
                child: Container(
                  width: circleButtonSize,
                  height: circleButtonSize,
                  decoration: BoxDecoration(
                    color: circleButtonColor,
                    borderRadius: BorderRadius.circular(circleRadius),
                    border: Border.all(
                      color: circleButtonBorderColor,
                      width: circleStrokeWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              // TODO camera
              color: Colors.black,
            ),
          ),
          _buildHeader,
          _buildElipsedBottomButton,
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
