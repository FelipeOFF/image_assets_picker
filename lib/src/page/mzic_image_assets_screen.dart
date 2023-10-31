import 'package:flutter/material.dart';
import 'package:mzic_image_assets_picker/src/component/mzic_crop_viewer.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

const _kInitializeDelayDuration = Duration(milliseconds: 250);

typedef OnPermissionDenied = void Function(BuildContext context, String errorDescription);

class MzicImageAssetsScreen extends StatefulWidget {
  // App bar struct

  final PreferredSizeWidget? appBar;
  final String? title;
  final Color? appBarBackgroundColor;
  final Widget? leading;
  final String? leadingText;
  final TextStyle? leadingTextStyle;
  final ButtonStyle? leadingButtonStyle;
  final VoidCallback? onLeadingPressed;
  final bool isCloseButton;
  final Widget? action;
  final String? actionText;
  final TextStyle? actionTextStyle;
  final ButtonStyle? actionButtonStyle;
  final VoidCallback? onActionPressed;
  final bool isDoneButton;

  // End app bar struct

  final List<AssetEntity>? selectedAssets;
  final int maxAssets;
  final int pageSize;
  final ThumbnailSize pathThumbnailSize;
  final SortPathDelegate<AssetPathEntity>? sortPathDelegate;
  final bool sortPathsByModifiedDate;
  final FilterOptionGroup? filterOptions;
  final Duration initializeDelayDuration;
  final OnPermissionDenied? onPermissionDenied;
  final AssetPickerTextDelegate? textDelegate;
  final Widget? loadingWidget;

  const MzicImageAssetsScreen({
    super.key,
    this.appBar,
    this.title,
    this.appBarBackgroundColor,
    this.leading,
    this.leadingText,
    this.onLeadingPressed,
    this.isCloseButton = true,
    this.action,
    this.actionText,
    this.onActionPressed,
    this.isDoneButton = true,
    this.leadingTextStyle,
    this.actionTextStyle,
    this.leadingButtonStyle,
    this.actionButtonStyle,
    this.selectedAssets,
    this.maxAssets = defaultMaxAssetsCount,
    this.pageSize = defaultAssetsPerPage,
    this.pathThumbnailSize = defaultPathThumbnailSize,
    this.sortPathDelegate = SortPathDelegate.common,
    this.filterOptions,
    this.sortPathsByModifiedDate = false,
    this.initializeDelayDuration = _kInitializeDelayDuration,
    this.onPermissionDenied,
    this.textDelegate,
    this.loadingWidget,
  });

  @override
  State<MzicImageAssetsScreen> createState() => _MzicImageAssetsScreenState();
}

class _MzicImageAssetsScreenState extends State<MzicImageAssetsScreen> {
  String get _title => widget.title ?? "Select images";

  Color get _appBarBackgroundColor => widget.appBarBackgroundColor ?? Theme.of(context).colorScheme.inversePrimary;

  String get _leadingText => widget.leadingText ?? "Cancel";

  VoidCallback? get _onLeadingPressed =>
      widget.onLeadingPressed ?? (widget.isCloseButton ? () => Navigator.pop(context) : null);

  TextStyle get _leadingTextStyle =>
      widget.leadingTextStyle ??
      const TextStyle(
        color: Colors.white,
      );

  ButtonStyle get _leadingButtonStyle =>
      widget.leadingButtonStyle ??
      ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
      );

  Widget get _leading =>
      widget.leading ??
      TextButton(
        onPressed: _onLeadingPressed,
        style: _leadingButtonStyle,
        child: Text(
          _leadingText,
          style: _leadingTextStyle,
        ),
      );

  String get _actionText => widget.actionText ?? "Done";

  VoidCallback? get _onActionPressed =>
      widget.onActionPressed ?? (widget.isDoneButton ? () => Navigator.pop(context) : null);

  TextStyle get _actionTextStyle =>
      widget.actionTextStyle ??
      const TextStyle(
        color: Colors.white,
      );

  ButtonStyle get _actionButtonStyle =>
      widget.actionButtonStyle ??
      ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
      );

  Widget get _action =>
      widget.action ??
      TextButton(
        onPressed: _onActionPressed,
        style: _actionButtonStyle,
        child: Text(
          _actionText,
          style: _actionTextStyle,
        ),
      );

  PreferredSizeWidget get _appBar {
    return widget.appBar ??
        AppBar(
          leading: _leading,
          actions: [_action],
          leadingWidth: 81,
          backgroundColor: _appBarBackgroundColor,
          title: Center(
            child: Text(_title),
          ),
        );
  }

  List<AssetEntity>? get selectedAssets => widget.selectedAssets;

  int get maxAssets => widget.maxAssets;

  int get pageSize => widget.pageSize;

  ThumbnailSize get pathThumbnailSize => widget.pathThumbnailSize;

  SortPathDelegate<AssetPathEntity>? get sortPathDelegate => widget.sortPathDelegate;

  bool get sortPathsByModifiedDate => widget.sortPathsByModifiedDate;

  FilterOptionGroup? get filterOptions => widget.filterOptions;

  Duration get initializeDelayDuration => widget.initializeDelayDuration;

  late final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
    selectedAssets: selectedAssets,
    maxAssets: maxAssets,
    pageSize: pageSize,
    pathThumbnailSize: pathThumbnailSize,
    requestType: RequestType.image,
    sortPathDelegate: sortPathDelegate,
    sortPathsByModifiedDate: sortPathsByModifiedDate,
    filterOptions: filterOptions,
    initializeDelayDuration: initializeDelayDuration,
  );

  OnPermissionDenied? get onPermissionDenied => widget.onPermissionDenied;

  AssetPickerTextDelegate get textDelegate => widget.textDelegate ?? defaultTextDelegate(context);

  Widget get loadingWidget => widget.loadingWidget ?? const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkPermission(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == PermissionState.denied) {
          _openErrorPermission(context, textDelegate, onPermissionDenied);
          return const SizedBox.shrink();
        } else if (!snapshot.hasData) {
          return loadingWidget;
        }
        return ChangeNotifierProvider.value(
          value: provider,
          child: Scaffold(
            appBar: _appBar,
            body: Column(
              children: [
                MzicCropViewer(
                  loadingWidget: loadingWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<PermissionState?> _checkPermission() async {
    try {
      return await AssetPicker.permissionCheck();
    } catch (e) {
      _openErrorPermission(context, textDelegate, onPermissionDenied);
      return null;
    }
  }

  AssetPickerTextDelegate defaultTextDelegate(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context);
    return assetPickerTextDelegateFromLocale(locale);
  }

  void _openErrorPermission(
    BuildContext context,
    AssetPickerTextDelegate textDelegate,
    Function(BuildContext, String)? customHandler,
  ) {
    final defaultDescription = '${textDelegate.unableToAccessAll}\n${textDelegate.goToSystemSettings}';

    if (customHandler != null) {
      customHandler(context, defaultDescription);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(defaultDescription)),
      );
    }
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }
}
