import 'package:flutter/material.dart';

class MzicImageAssetsScreen extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final String? title;
  final Color? appBarBackgroundColor;

  const MzicImageAssetsScreen({
    super.key,
    this.appBar,
    this.title,
    this.appBarBackgroundColor,
  });

  @override
  State<MzicImageAssetsScreen> createState() => _MzicImageAssetsScreenState();
}

class _MzicImageAssetsScreenState extends State<MzicImageAssetsScreen> {

  String get _title => widget.title ?? "Mzic Image Assets Picker";
  Color get _appBarBackgroundColor => widget.appBarBackgroundColor ?? Theme.of(context).colorScheme.inversePrimary;

  PreferredSizeWidget get _appBar {
    return widget.appBar ??
        AppBar(
          backgroundColor: _appBarBackgroundColor,
          title: Text(_title),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
    );
  }
}
