import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dmzj/app/http_util.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:flutter_dmzj/controllers/news/news_detail_controller.dart';
import 'package:flutter_dmzj/widgets/icon_text_button.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:universal_html/parsing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailPage extends StatelessWidget {
  NewsDetailPage({Key? key}) : super(key: key);
  final NewsDetailController controller = Get.put(NewsDetailController());
  final title = (Get.arguments as Map)['title'] ?? "";
  final url = (Get.arguments as Map)['url'] ?? "";
  final newsId = (Get.arguments as Map)['id'] ?? 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 2,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1?.color),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Utils.share("$title\r\n$url");
            },
          )
        ],
      ),
      body: (Platform.isAndroid || Platform.isIOS)
          ? WebView(
              navigationDelegate: (args) {
                var uri = Uri.parse(args.url);
                print(args.url);
                if (uri.scheme == "dmzjimage") {
                  Utils.showImageViewDialog(
                      context, uri.queryParameters["src"]);
                } else if (uri.scheme == "dmzjandroid") {
                  //print(uri.path);
                  Utils.openPage(context, int.parse(uri.queryParameters["id"]!),
                      uri.path == "/cartoon_description" ? 1 : 2);
                  //print(uri.queryParameters["id"]);
                } else if (uri.scheme == "https" || uri.scheme == "http") {
                  //_controller.loadUrl(args.url);
                  return NavigationDecision.navigate;
                }

                return NavigationDecision.prevent;
              },
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (e) {
                //try {
                //_controller.evaluateJavascript(
                // "\$(\".news_box\").css(\"min-height\",\"680px\");");
                //} catch (e) {
                //}
              },
            )
          : DesktopContent(url),
      bottomNavigationBar: Offstage(
        offstage: newsId == 0,
        child: BottomAppBar(
          child: Row(
            children: <Widget>[
              Obx(
                () => IconTextButton(
                  Icon(
                    controller.liked.value
                        ? Ionicons.heart
                        : Ionicons.heart_outline,
                    size: 20.0,
                  ),
                  "点赞(${controller.moodCount.value})",
                  controller.addLike,
                ),
              ),
              Obx(
                () => IconTextButton(
                  Icon(
                    Ionicons.chatbox_ellipses_outline,
                    size: 20.0,
                  ),
                  "评论(${controller.commentCount.value})",
                  () => Utils.openCommentPage(
                    context,
                    controller.newsId,
                    6,
                    title,
                  ),
                ),
              ),
              Obx(
                () => IconTextButton(
                  Icon(
                    controller.subscribed.value
                        ? Ionicons.star
                        : Ionicons.star_outline,
                    size: 20.0,
                  ),
                  controller.subscribed.value ? "已收藏" : "收藏",
                  controller.addOrDelNewsSubscribe,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopContent extends StatefulWidget {
  final String pageUrl;
  DesktopContent(this.pageUrl, {Key? key}) : super(key: key);

  @override
  _DesktopContentState createState() => _DesktopContentState();
}

class _DesktopContentState extends State<DesktopContent> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    loadHtml();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  String _kHtml = "<p></p>";
  String _author = "", _src = "动漫之家", _time = "";
  String _title = "";
  void loadHtml() async {
    try {
      var result = await HttpUtil.instance.httpGet(widget.pageUrl);
      final htmlDocument = parseHtmlDocument(result);
      var news = htmlDocument.documentElement?.querySelector('.news_box');
      var title = htmlDocument.documentElement?.querySelector('.min_box_tit');

      setState(() {
        _kHtml = news?.innerHtml ?? "";
        _title = title?.innerText ?? "";
        _author =
            htmlDocument.documentElement?.querySelector('.txt1')?.innerText ??
                "";
        _src =
            htmlDocument.documentElement?.querySelector('.txt2')?.innerText ??
                "";
        _time =
            htmlDocument.documentElement?.querySelector('.txt3')?.innerText ??
                "";
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.all(12),
        children: [
          SelectableText(
            _title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 4,
          ),
          SelectableText(
            "$_author $_src $_time",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(
            height: 12,
          ),
          HtmlWidget(
            _kHtml,
            customWidgetBuilder: (e) {
              if (e.localName == "img") {
                var imgSrc = e.attributes["src"];
                if (imgSrc == null) {
                  imgSrc = e.attributes["data-original"];
                }
                return InkWell(
                  child: CachedNetworkImage(
                    imageUrl: imgSrc ?? "",
                    httpHeaders: {"Referer": "http://www.dmzj.com/"},
                    fit: BoxFit.fitWidth,
                  ),
                  onTap: () {
                    Utils.showImageViewDialog(
                      context,
                      imgSrc,
                    );
                  },
                );
              }

              return null;
            },
            textStyle: TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
            onTapUrl: (url) {
              var uri = Uri.parse(url);
              if (uri.scheme == "dmzjimage") {
                Utils.showImageViewDialog(context, uri.queryParameters["src"]);
                return;
              }
              if (uri.scheme == "dmzjandroid") {
                Utils.openPage(
                    context,
                    int.parse(uri.queryParameters["id"] ?? "0"),
                    uri.path == "/cartoon_description" ? 1 : 2);
                return;
              }
              if (uri.scheme == "https" || uri.scheme == "http") {
                launch(url);
              }
            },
          )
        ],
      ),
    );
  }
}
