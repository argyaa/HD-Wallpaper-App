import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper/pages/detail.dart';
import 'package:shimmer/shimmer.dart';

Widget ImageCard(String imgUrl, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => DetailPage(imgUrl),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        placeholder: (context, url) => placeHolder(),
        imageUrl: imgUrl,
        errorWidget: (context, url, error) => Image.network(
            'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
      ),
    ),
  );
}

Widget placeHolder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[400],
    highlightColor: Colors.grey[300],
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 200,
        color: Colors.grey[350],
      ),
    ),
  );
}
// }
