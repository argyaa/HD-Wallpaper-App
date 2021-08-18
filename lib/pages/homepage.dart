import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:wallpaper/models/search_model.dart';
import 'package:wallpaper/provider/image_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper/provider/search_provider.dart';
import 'package:wallpaper/widgets/image_card.dart';
import 'package:nanoid/nanoid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController;

  @override
  void initState() {
    final SearchProvider searchProvider =
        Provider.of<SearchProvider>(context, listen: false);

    super.initState();
    searchController = TextEditingController(text: searchProvider.keyword);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var id = customAlphabet('1234567890', 10);
    // ignore: non_constant_identifier_names
    var custom_length_id = nanoid(10);
    print(id);
    print(custom_length_id);
    var imageProvider = Provider.of<ImageProviders>(context);
    var searchProvider = Provider.of<SearchProvider>(context);

    final List<Widget> placeHolder = List.generate(
      10,
      (index) => Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.grey[300],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 200,
            color: Colors.grey[350],
          ),
        ),
      ),
    );

    Widget searchBox() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.red,
              ),
              child: Center(
                child: TextFormField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    searchProvider.keyword = value;
                  },
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    prefixIcon: Image.asset(
                      "assets/search-normal.png",
                      width: 24,
                      height: 24,
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 28, bottom: 20, top: 20),
                    fillColor: Color(0xffF1F0F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.blue[300],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: '',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // NOTE BIKIN CATEGORIES WALLPAPER
    Widget categories() {
      return ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            child: Container(),
          )
        ],
      );
    }

    Widget header() {
      return Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("HD Wallpaper")
                  .fontSize(20)
                  .fontWeight(FontWeight.bold)
                  .textColor(Colors.black),
            ],
          ),
          SizedBox(height: 40),
          searchBox(),
          SizedBox(height: 40),
        ],
      );
    }

    Widget result() {
      return Column(
        children: [
          FutureBuilder<SearchModel>(
            future: imageProvider.getResult(searchProvider.keyword.isEmpty
                ? "wallpaper"
                : searchProvider.keyword + " wallpaper"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var img = snapshot.data.result;

                // print("result ${snapshot.data.creator}");

                return StaggeredGridView.countBuilder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  itemCount: img.length,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    return ImageCard(img[index], context);
                  },
                );
              }
              return StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                itemCount: 10,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  return placeHolder[index];
                },
              );
            },
          ),
        ],
      );
    }

    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: ListView(
            physics: ScrollPhysics(),
            children: [
              header(),
              result(),
            ],
          )),
    ));
  }
}
