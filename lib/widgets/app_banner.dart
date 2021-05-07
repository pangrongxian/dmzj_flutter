import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AppBanner extends StatefulWidget {
  final List<Widget> items;

  AppBanner({Key? key, required this.items}) : super(key: key);

  _AppBannerState createState() => _AppBannerState();
}

class _AppBannerState extends State<AppBanner> {
  int currentBannerIndex = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var viewportFraction = width <= 500 ? 1.0 : 0.4;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (i, e) {
                setState(() {
                  currentBannerIndex = i;
                });
              },
              aspectRatio: 7.5 / (4 * viewportFraction),
              viewportFraction: viewportFraction,
              autoPlay: true,
              // enlargeCenterPage: width > 500,
              //enlargeStrategy: CenterPageEnlargeStrategy.height,
            ),
            items: widget.items.length != 0
                ? widget.items
                : [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
          ),
          Positioned(
            right: 8.0,
            bottom: 4.0,
            child: Visibility(
              visible: width <= 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.items.map<Widget>((index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentBannerIndex == widget.items.indexOf(index)
                          ? Theme.of(context).accentColor
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BannerImageItem extends StatelessWidget {
  final String? pic;
  final Function? onTaped;
  final String? title;
  BannerImageItem({Key? key, this.pic, this.onTaped, this.title = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTaped as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: pic!,
                fit: BoxFit.cover,
                httpHeaders: {"Referer": "http://www.dmzj.com/"},
                placeholder: (context, url) => Center(
                  child: Center(child: Icon(Icons.photo)),
                ),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
              Positioned(
                bottom: 4,
                left: 8,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
