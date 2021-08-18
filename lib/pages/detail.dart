import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/loading_provider.dart';
import 'package:wallpaper/provider/progres_provider.dart';
import 'package:nanoid/nanoid.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DetailPage extends StatelessWidget {
  String imgUrl;
  DetailPage(this.imgUrl);
  final Dio dio = Dio();
  var name = "";

  getFileName() {
    name = "Img" + customAlphabet('1234567890', 10).toString() + ".jpg";
    return name;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var progressProvider = Provider.of<ProgressProvider>(context);
    var loadingProvider = Provider.of<LoadingProvider>(context);

    Future<bool> saveFile(String url, String fileName) async {
      var directory;
      try {
        if (Platform.isAndroid) {
          if (await _requestPermission(Permission.storage)) {
            directory = await ExtStorage.getExternalStoragePublicDirectory(
                ExtStorage.DIRECTORY_PICTURES);
            print("HOME DIRECTORY : " + directory);
            directory = directory + "/HD Wallpaper";
            directory = Directory(directory);
            print(directory.path);
          } else {
            return false;
          }
        } else {
          //NOTE buat DIRECTORY IOS
          if (await _requestPermission(Permission.photos)) {
            directory = await getTemporaryDirectory();
          } else {
            return false;
          }
        }

        File saveFile = File(directory.path + "/$fileName");
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        if (await directory.exists()) {
          await dio.download(url, saveFile.path,
              onReceiveProgress: (downloaded, totalsize) {
            progressProvider.progress = downloaded / totalsize;
          });

          if (Platform.isIOS) {
            await ImageGallerySaver.saveFile(saveFile.path,
                isReturnPathOfIOS: true);
          }

          return true;
        }
        return false;
      } catch (e) {
        print(e);
        return false;
      }
    }

    downloadFile(String url, String filename) async {
      loadingProvider.loading = true;

      bool downloaded = await saveFile(url, filename);

      if (downloaded) {
        print("File Downloaded");
      } else {
        print("problem downloading file");
      }
      loadingProvider.loading = false;
    }

    savedialogSuccess() {
      showDialog(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
                title: new Text('Success'),
                content: new Text(
                    'Your wallpaper has saved in \n /storage/emulated/0/Pictures/HD Wallpaper'),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
    }

    homedialogSuccess() {
      showDialog(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
                title: new Text('Success'),
                content: new Text('Your Home screen wallpaper has changed'),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
    }

    lockdialogSuccess() {
      showDialog(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
                title: new Text('Success'),
                content: new Text('Your Lock screen wallpaper has changed'),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
    }

    setToHome(String imgUrl) async {
      String url = imgUrl;
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final String result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
    }

    setToLock(String imgUrl) async {
      String url = imgUrl;
      int location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final String result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
    }

    // ignore: unused_element
    showModal() {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          context: context,
          builder: (context) {
            return Container(
              height: 290,
              padding: EdgeInsets.symmetric(
                vertical: 50,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Set your wallpaper to ?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () async {
                      print("set to home screen");
                      await setToHome(imgUrl);
                      homedialogSuccess();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                      ),
                      padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Text(
                        "Set to Home Screen",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () async {
                      print("Set to Lock Screen");
                      await setToLock(imgUrl);
                      lockdialogSuccess();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                      ),
                      padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Text(
                        "Set to Lock Screen",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: imgUrl,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  placeholder: (context, url) => Container(
                    color: Color(0xfff5f8fd),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 16),
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          print("save wallpaper");
                          await downloadFile(imgUrl, getFileName());
                          savedialogSuccess();
                        },
                        child: BlurryContainer(
                          borderRadius: BorderRadius.circular(30),
                          bgColor: Colors.orange,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          child: (!loadingProvider.loading)
                              ? Text(
                                  "Save Wallpaper",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )
                              : Center(
                                  child: LinearPercentIndicator(
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.4,
                                    backgroundColor: Colors.orange,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 0,
                                    percent: progressProvider.progress,
                                    center: Text(
                                        (progressProvider.progress * 100)
                                                .round()
                                                .toString() +
                                            "%"),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.white,
                                  ),
                                ),
                        )),
                    SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        print("set as wallpapar");
                        showModal();
                      },
                      child: BlurryContainer(
                        borderRadius: BorderRadius.circular(30),
                        bgColor: Colors.grey[350],
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Text(
                          "Set as wallpaper",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
