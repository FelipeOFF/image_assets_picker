import 'package:flutter/material.dart';

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
  });

  @override
  State<MzicImageAssetsScreen> createState() => _MzicImageAssetsScreenState();
}

class _MzicImageAssetsScreenState extends State<MzicImageAssetsScreen> {
  String get _title => widget.title ?? "Select images";

  Color get _appBarBackgroundColor =>
      widget.appBarBackgroundColor ??
      Theme.of(context).colorScheme.inversePrimary;

  String get _leadingText => widget.leadingText ?? "Cancel";

  VoidCallback? get _onLeadingPressed =>
      widget.onLeadingPressed ??
      (widget.isCloseButton ? () => Navigator.pop(context) : null);

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
      widget.onActionPressed ??
      (widget.isDoneButton ? () => Navigator.pop(context) : null);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
    );
  }
}
