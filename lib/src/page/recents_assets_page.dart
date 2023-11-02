import 'dart:typed_data' as typed_data;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class RecentsAssetsPage extends StatefulWidget {
  final DefaultAssetPickerProvider provider;
  final PreferredSizeWidget? appBar;
  final Color? appBarBackgroundColor;
  final Widget? leading;
  final String? leadingText;
  final VoidCallback? onLeadingPressed;
  final ButtonStyle? leadingButtonStyle;
  final TextStyle? leadingTextStyle;
  final String? title;
  final PermissionState permission;
  final double thumbSize;
  final PathNameBuilder<AssetPathEntity>? pathNameBuilder;
  final TextStyle? nameTextStyle;
  final TextStyle? countTextStyle;
  final Color? screenBackgroundColor;

  const RecentsAssetsPage({
    super.key,
    this.appBar,
    this.leading,
    this.leadingText,
    this.onLeadingPressed,
    this.leadingButtonStyle,
    this.leadingTextStyle,
    this.title,
    this.appBarBackgroundColor,
    required this.provider,
    this.pathNameBuilder,
    this.permission = PermissionState.notDetermined,
    this.thumbSize = 80,
    this.nameTextStyle,
    this.countTextStyle, this.screenBackgroundColor,
  });

  @override
  State<RecentsAssetsPage> createState() => _RecentsAssetsPageState();
}

class _RecentsAssetsPageState extends State<RecentsAssetsPage> {
  VoidCallback? get _onLeadingPressed => widget.onLeadingPressed ?? (() => Navigator.pop(context));

  ButtonStyle get _leadingButtonStyle =>
      widget.leadingButtonStyle ??
      ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
      );

  String get _leadingText => widget.leadingText ?? "Cancel";

  TextStyle get _leadingTextStyle =>
      widget.leadingTextStyle ??
      const TextStyle(
        color: Colors.white,
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

  Color get _appBarBackgroundColor => widget.appBarBackgroundColor ?? Theme.of(context).colorScheme.inversePrimary;

  String get _title => widget.title ?? "Library";

  PreferredSizeWidget get _appBar {
    return widget.appBar ??
        AppBar(
          leading: _leading,
          actions: [
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: _leading,
            ),
          ],
          centerTitle: true,
          leadingWidth: 81,
          backgroundColor: _appBarBackgroundColor,
          title: Center(
            child: Text(_title),
          ),
        );
  }

  bool get isPermissionLimited => widget.permission == PermissionState.limited;

  TextStyle get nameTextStyle =>
      widget.nameTextStyle ??
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  TextStyle get countTextStyle =>
      widget.countTextStyle ??
      TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.provider,
      child: Scaffold(
        backgroundColor: widget.screenBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        appBar: _appBar,
        body: Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
            selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
            builder: (context, currentWrapper, _) {
              return Selector<DefaultAssetPickerProvider, List<PathWrapper<AssetPathEntity>>>(
                selector: (_, provider) => provider.paths,
                builder: (context, List<PathWrapper<AssetPathEntity>> paths, __) {
                  final List<PathWrapper<AssetPathEntity>> filtered = paths
                      .where(
                        (PathWrapper<AssetPathEntity> p) => p.assetCount != 0,
                      )
                      .toList();
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsetsDirectional.only(top: 1),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final PathWrapper<AssetPathEntity> wrapper = filtered[index];
                      final AssetPathEntity pathEntity = wrapper.path;
                      final typed_data.Uint8List? data = wrapper.thumbnailData;

                      // final bool isSelected = currentWrapper?.path == pathEntity;

                      final String pathName = widget.pathNameBuilder?.call(pathEntity) ?? pathEntity.name;
                      final String name = isPermissionLimited && pathEntity.isAll ? "Permission" : pathName;
                      final String? semanticsCount = wrapper.assetCount?.toString();

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context).pop(wrapper);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: widget.thumbSize,
                                  height: widget.thumbSize,
                                  child: RepaintBoundary(
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: _getThumb(
                                        data,
                                        pathEntity,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: nameTextStyle,
                                      ),
                                      Text(
                                        semanticsCount.toString(),
                                        style: countTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, __) => const SizedBox(
                      height: 12,
                    ),
                  );
                },
              );
            }),
      ),
    );
  }

  Widget _getThumb(typed_data.Uint8List? data, AssetPathEntity pathEntity) {
    if (data != null) {
      return Image.memory(data, fit: BoxFit.cover);
    }
    if (pathEntity.type.containsAudio()) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        child: const Center(child: Icon(Icons.audiotrack)),
      );
    }
    return ColoredBox(color: Theme.of(context).colorScheme.primary.withOpacity(0.12));
  }
}
