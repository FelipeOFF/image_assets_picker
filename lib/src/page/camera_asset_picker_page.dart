import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_assets_picker/src/controller/camera_asset_picker_controller.dart';

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
  });

  @override
  State<CameraAssetPickerPage> createState() => _CameraAssetPickerPageState();
}

class _CameraAssetPickerPageState extends State<CameraAssetPickerPage> with TickerProviderStateMixin {
  late final AnimationController _animationFlashController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final AnimationController _animationTransitionViewController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  double get _animationFlashControllerValue => _animationFlashController.value;

  double get _animationTransitionViewControllerValue => _animationTransitionViewController.value;

  late final CameraAssetPickerController controller = widget.controller ?? CameraAssetPickerController();
  late CameraController cameraController = widget.cameraController ??
      CameraController(
        controller.camera,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      )
    ..setFlashMode(controller.flashState ? FlashMode.always : FlashMode.off);

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
        cameraController = CameraController(
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
      child: Transform.scale(
        scale: scale,
        child: Center(
          child: CameraPreview(cameraController),
        ),
      ),
    );
  }

  Widget get cameraWidget => widget.cameraWidgetBuilder != null ? widget.cameraWidgetBuilder!() : _buildCameraWidget();

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
          color: Colors.white,
        ),
      );

  Widget get headerCoverAnimation => Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 77,
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
            // TODO add buttons
            color: const Color(0xFF160F29),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        controller.init(),
        cameraController.initialize(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return _buildLoadingWidget();
        }

        return Scaffold(
          body: Stack(
            children: [
              cameraWidget,
              animatedFlash,
              headerCoverAnimation,
              _buildHeader,
              _buildElipsedBottomButton,
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePicture() async {
    await _animationFlashController.forward();
    await _animationFlashController.reverse();
    await _animationTransitionViewController.forward();
    await _animationTransitionViewController.reverse(); // TODO remove it
    // await cameraController.pausePreview();
    // final image = await cameraController.takePicture();
    // TODO handle image
  }

  @override
  void dispose() {
    controller.dispose();
    cameraController.dispose();
    super.dispose();
  }
}
