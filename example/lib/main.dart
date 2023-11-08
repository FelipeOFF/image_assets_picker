import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_assets_picker/image_assets_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Image Assets Picker demo"),
      ),
      body: ImageAssetsPage(
        onActionPressed: (Stream<InstaAssetsExportDetails> asset) async {
          await for (final InstaAssetsExportDetails asset in asset) {
            if (kDebugMode) {
              print(asset);
            }
          }
        }
      ),
    );
  }
}
