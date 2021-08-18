import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/pages/homepage.dart';
import 'package:wallpaper/provider/image_provider.dart';
import 'package:wallpaper/provider/loading_provider.dart';
import 'package:wallpaper/provider/progres_provider.dart';
import 'package:wallpaper/provider/search_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageProviders>(
            create: (context) => ImageProviders()),
        ChangeNotifierProvider<ProgressProvider>(
            create: (context) => ProgressProvider()),
        ChangeNotifierProvider<LoadingProvider>(
            create: (context) => LoadingProvider()),
        ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
