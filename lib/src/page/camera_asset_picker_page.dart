import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:image_assets_picker/src/component/crop_view.dart';
import 'package:image_assets_picker/src/controller/camera_asset_picker_controller.dart';

typedef OnSavePressed = Future<void> Function(File? asset);

class CameraAssetPickerPage extends StatefulWidget {
  final CameraAssetPickerController? controller;
  final CameraController? cameraController;

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

  // Loading

  final Widget Function()? loadingWidgetBuilder;

  // Loading

  // Camera

  final Widget Function()? cameraWidgetBuilder;

  // Camera

  // Flash

  final Color? flashColor;

  // Flash

  // Shape Header

  final Color? shapeHeaderColor;
  final double? shapeHeaderHeight;

  // Shape Header

  // Shape Bottom

  final Color? shapeBottomColor;
  final double? shapeBottomHeight;

  // Shape Bottom

  // Bottom Buttons

  final Widget Function(AnimationController)? bottomButtonsBuilder;
  final EdgeInsets? textButtonsPadding;

  // Bottom Buttons

  // Retake Button

  final String? retakeButtonText;
  final Color? retakeButtonColor;

  // Retake Button

  // Use photo button

  final String? usePhotoButtonText;
  final Color? usePhotoButtonColor;

  // Use photo button

  // Top Buttons

  final Widget Function(AnimationController)? topButtonsBuilder;

  // Top Buttons

  // Top Cancel button

  final String? cancelButtonText;
  final Color? cancelButtonColor;

  // Top Cancel button

  // Top Save button

  final String? saveButtonText;
  final Color? saveButtonColor;

  // Top Save button

  // Crop button rotate

  final Widget? cropButtonRotate;
  final Widget? cropButtonIcon;
  final Color? cropButtonColor;

  // Crop button rotate

  // CropView

  final Color? cropViewBackgroundColor;

  // CropView

  // Event finish crop

  final OnSavePressed? onSavePressed;

  // Event finish crop

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
    this.onPressedRotateCamera,
    this.circleButtonTakePicture,
    this.onPressedTakePicture,
    this.circleButtonColor,
    this.circleButtonBorderColor,
    this.circleButtonSize,
    this.circleStrokeWidth,
    this.circleRadius,
    this.circleButtonPadding,
    this.cameraController,
    this.loadingWidgetBuilder,
    this.cameraWidgetBuilder,
    this.flashColor,
    this.shapeHeaderColor,
    this.shapeHeaderHeight,
    this.shapeBottomColor,
    this.shapeBottomHeight,
    this.bottomButtonsBuilder,
    this.textButtonsPadding,
    this.retakeButtonText,
    this.retakeButtonColor,
    this.usePhotoButtonText,
    this.usePhotoButtonColor,
    this.topButtonsBuilder,
    this.cancelButtonText,
    this.cancelButtonColor,
    this.saveButtonText,
    this.saveButtonColor,
    this.cropButtonRotate,
    this.cropButtonIcon,
    this.cropButtonColor,
    this.cropViewBackgroundColor,
    this.onSavePressed,
  });

  @override
  State<CameraAssetPickerPage> createState() => _CameraAssetPickerPageState();
}

class _CameraAssetPickerPageState extends State<CameraAssetPickerPage> with TickerProviderStateMixin {
  final GlobalKey _cropKey = GlobalKey(debugLabel: 'cropperKey');

  late final AnimationController _animationFlashController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final AnimationController _animationTransitionViewController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final AnimationController _animationTransitionHeaderButtonController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  double get _animationFlashControllerValue => _animationFlashController.value;

  double get _animationTransitionViewControllerValue => _animationTransitionViewController.value;

  double get _animationTransitionHeaderButtonControllerValue => _animationTransitionHeaderButtonController.value;

  CameraAssetPickerController? _controller;

  CameraAssetPickerController get controller {
    _controller ??= widget.controller ?? CameraAssetPickerController();
    return _controller!;
  }

  CameraController get _initializeCameraController => CameraController(
        controller.camera,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      )..setFlashMode(controller.flashState ? FlashMode.always : FlashMode.off);
  CameraController? _cameraController;

  CameraController get cameraController {
    _cameraController ??= _initializeCameraController;
    return _cameraController!;
  }

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
      () async {
        controller.toggleFlashState();
        await cameraController.setFlashMode(controller.flashState ? FlashMode.always : FlashMode.off);
      };

  VoidCallback get onPressedRotateCamera =>
      widget.onPressedRotateCamera ??
      () async {
        controller.toggleCamera();
        _cameraController = CameraController(
          controller.camera,
          ResolutionPreset.max,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await cameraController.initialize();

        setState(() {});
      };

  VoidCallback get onPressedTakePicture => widget.onPressedTakePicture ?? _takePicture;

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
        child: AnimatedBuilder(
          animation: _animationTransitionViewController,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: _animationTransitionViewControllerValue == 1,
              child: Opacity(
                opacity: 1.0 - _animationTransitionViewControllerValue,
                child: child,
              ),
            );
          },
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
        ),
      );

  Color get circleButtonColor => widget.circleButtonColor ?? const Color(0xFFD9D9D9).withOpacity(0.3);

  Color get circleButtonBorderColor => widget.circleButtonBorderColor ?? const Color(0xFFE6E6EA);

  double get circleButtonSize => widget.circleButtonSize ?? 72;

  double get circleStrokeWidth => widget.circleStrokeWidth ?? 3;

  double get circleRadius => widget.circleRadius ?? 36;

  EdgeInsets get circleButtonPadding => widget.circleButtonPadding ?? const EdgeInsets.only(bottom: 47.0);

  Widget get _buildElipsedBottomButton =>
      widget.circleButtonTakePicture ??
      Positioned(
        right: 0,
        left: 0,
        bottom: 0,
        child: AnimatedBuilder(
          animation: _animationTransitionViewController,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: _animationTransitionViewControllerValue == 1,
              child: Opacity(
                opacity: 1.0 - _animationTransitionViewControllerValue,
                child: child,
              ),
            );
          },
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
        ),
      );

  Widget _buildLoadingWidget() => widget.loadingWidgetBuilder != null
      ? widget.loadingWidgetBuilder!()
      : const Center(
          child: CircularProgressIndicator(),
        );

  Widget _buildCameraWidget() {
    var camera = cameraController.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animationTransitionHeaderButtonController,
        builder: (context, child) {
          return IgnorePointer(
            ignoring: _animationTransitionHeaderButtonControllerValue == 1,
            child: Opacity(
              opacity: 1.0 - _animationTransitionHeaderButtonControllerValue,
              child: child,
            ),
          );
        },
        child: Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(cameraController),
          ),
        ),
      ),
    );
  }

  Widget get cameraWidget => widget.cameraWidgetBuilder != null ? widget.cameraWidgetBuilder!() : _buildCameraWidget();

  Color get flashColor => widget.flashColor ?? Colors.white;

  Widget get animatedFlash => AnimatedBuilder(
        animation: _animationFlashController,
        builder: (context, child) {
          return IgnorePointer(
            ignoring: _animationFlashControllerValue == 0,
            child: Opacity(
              opacity: _animationFlashControllerValue,
              child: child,
            ),
          );
        },
        child: Container(
          color: flashColor,
        ),
      );

  Color get shapeHeaderColor => widget.shapeHeaderColor ?? const Color(0xFF160F29);

  double get shapeHeaderHeight => widget.shapeHeaderHeight ?? 77;

  Color get cancelButtonColor => widget.cancelButtonColor ?? const Color(0xFFE6E6EA);

  String get cancelButtonText => widget.cancelButtonText ?? "Cancel";

  String get saveButtonText => widget.saveButtonText ?? "Save";

  Color get saveButtonColor => widget.saveButtonColor ?? const Color(0xFFE6E6EA);

  Future<void> _saveCropFile() async {
    await controller.saveCropedFile(Cropper.crop(cropperKey: _cropKey));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.onSavePressed != null) {
        widget.onSavePressed!(controller.cropedFile);
      } else {
        Navigator.pop(context, controller.cropedFile);
      }
    });
  }

  Row _buildTopButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildButton(
          cancelButtonText,
          cancelButtonColor,
          onPressed: () {
            _animationTransitionHeaderButtonController.reverse();
          },
        ),
        const Spacer(),
        ValueListenableBuilder(
          valueListenable: controller.isLoadingCroppedFileVN,
          builder: (context, isLoading, child) {
            if (isLoading || child == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: _buildLoadingWidget(),
                ),
              );
            }
            return child;
          },
          child: _buildButton(
            saveButtonText,
            saveButtonColor,
            onPressed: _saveCropFile,
          ),
        ),
      ],
    );
  }

  Widget get headerButtonTransition => AnimatedBuilder(
        animation: _animationTransitionHeaderButtonController,
        builder: (context, child) {
          return Opacity(
            opacity: _animationTransitionHeaderButtonControllerValue,
            child: child,
          );
        },
        child: _buildTopButtons(),
      );

  Widget get headerCoverAnimation => Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: shapeHeaderHeight,
        child: AnimatedBuilder(
          animation: _animationTransitionViewController,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: _animationTransitionViewControllerValue == 0,
              child: Opacity(
                opacity: _animationTransitionViewControllerValue,
                child: child,
              ),
            );
          },
          child: Container(
            color: shapeHeaderColor,
            child: headerButtonTransition,
          ),
        ),
      );

  Color get shapeBottomColor => widget.shapeBottomColor ?? const Color(0xFF160F29);

  double get shapeBottomHeight => widget.shapeBottomHeight ?? 106;

  EdgeInsets get bottomButtonsPadding =>
      widget.textButtonsPadding ??
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      );

  String get retakeButtonText => widget.retakeButtonText ?? "Retake";

  Color get retakeButtonColor => widget.retakeButtonColor ?? const Color(0xFFE6E6EA);

  String get usePhotoButtonText => widget.usePhotoButtonText ?? "Use photo";

  Color get usePhotoButtonColor => widget.usePhotoButtonColor ?? const Color(0xFF9976FF);

  Color get cropButtonColor => widget.cropButtonColor ?? Colors.white;

  Widget get buildCropButton =>
      widget.cropButtonIcon ??
      Icon(
        Icons.crop,
        color: cropButtonColor,
      );

  Widget get buildCropRotateButton =>
      widget.cropButtonRotate ??
      _buildIcon(
        icon: buildCropButton,
        onPressed: () {
          controller.rotationTurns = controller.rotationTurns + 1;
        },
      );

  Widget get _buildBottomButtons => AnimatedBuilder(
        animation: _animationTransitionHeaderButtonController,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 1.0 - _animationTransitionHeaderButtonControllerValue,
                  child: child,
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: _animationTransitionHeaderButtonControllerValue,
                  child: Center(
                    child: buildCropRotateButton,
                  ),
                ),
              )
            ],
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildButton(
              retakeButtonText,
              retakeButtonColor,
              onPressed: () {
                _animationTransitionViewController.reverse();
                cameraController.resumePreview();
              },
            ),
            const Spacer(),
            _buildButton(
              usePhotoButtonText,
              usePhotoButtonColor,
              onPressed: () async {
                await _animationTransitionHeaderButtonController.forward();
                await controller.saveFile();
              },
            ),
          ],
        ),
      );

  TextButton _buildButton(String buttonText, Color buttonColor, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          bottomButtonsPadding,
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: buttonColor,
        ),
      ),
    );
  }

  Color get cropViewBackgroundColor => widget.cropViewBackgroundColor ?? Colors.black.withOpacity(0.8);

  Widget get bottomCoverAnimation => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        height: shapeBottomHeight,
        child: AnimatedBuilder(
          animation: _animationTransitionViewController,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: _animationTransitionViewControllerValue == 0,
              child: Opacity(
                opacity: _animationTransitionViewControllerValue,
                child: child,
              ),
            );
          },
          child: Container(
            color: shapeBottomColor,
            child: widget.bottomButtonsBuilder != null
                ? widget.bottomButtonsBuilder!(_animationTransitionViewController)
                : _buildBottomButtons,
          ),
        ),
      );

  Widget get cropView => Positioned.fill(
        child: AnimatedBuilder(
          animation: _animationTransitionHeaderButtonController,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: _animationTransitionHeaderButtonControllerValue == 0,
              child: Opacity(
                opacity: _animationTransitionHeaderButtonControllerValue,
                child: child,
              ),
            );
          },
          child: ValueListenableBuilder(
              valueListenable: controller.rotationTurnsVN,
              builder: (context, rotationTurns, _) {
                return ValueListenableBuilder(
                  valueListenable: controller.croppedFileVN,
                  builder: (context, asset, _) {
                    if (asset == null) {
                      return _buildLoadingWidget();
                    }
                    return CropView(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      aspectRatio: 1.0,
                      cropKey: _cropKey,
                      image: asset,
                      rotationTurns: rotationTurns,
                      backgroundColor: cropViewBackgroundColor,
                    );
                  },
                );
              }),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.sync(() async {
        await controller.init();
        if (cameraController.value.isInitialized == false) {
          await cameraController.initialize();
        }
        return true;
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Navigator.of(context).pop();
          return const Center(
            child: Text("Error"),
          );
        } else if (snapshot.hasData == false) {
          return _buildLoadingWidget();
        }

        return Scaffold(
          body: Stack(
            children: [
              cameraWidget,
              cropView,
              animatedFlash,
              headerCoverAnimation,
              bottomCoverAnimation,
              _buildHeader,
              _buildElipsedBottomButton,
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePicture() async {
    final image = await cameraController.takePicture();
    await cameraController.pausePreview();
    controller.image = image;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _animationFlashController.forward();
      await _animationFlashController.reverse();
      await _animationTransitionViewController.forward();
    });
  }

  @override
  void dispose() {
    _animationFlashController.dispose();
    _animationTransitionViewController.dispose();
    _animationTransitionHeaderButtonController.dispose();
    controller.dispose();
    cameraController.dispose();
    _cameraController = null;
    _controller = null;
    super.dispose();
  }
}
