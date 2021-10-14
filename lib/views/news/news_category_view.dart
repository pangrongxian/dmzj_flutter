import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dmzj/app/page_navigator.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:flutter_dmzj/controllers/news/news_list_controller.dart';
import 'package:flutter_dmzj/protobuf/news/news_list_response.pb.dart';
import 'package:flutter_dmzj/widgets/app_banner.dart';
import 'package:flutter_dmzj/widgets/app_error_widget.dart';
import 'package:flutter_dmzj/widgets/border_card.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

class NewsCategoryView extends StatefulWidget {
  final int id;
  final bool hasBanner;
  NewsCategoryView(this.id, {this.hasBanner = false, Key? key})
      : super(key: key);

  @override
  NewsCategoryViewState createState() => NewsCategoryViewState();
}

class NewsCategoryViewState extends State<NewsCategoryView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ScrollController _scrollController = ScrollController();
  final HtmlUnescape _htmlUnescape = HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var columnNum = MediaQuery.of(context).size.width ~/ 400;
    if (columnNum < 1) columnNum = 1;
    if (columnNum > 3) columnNum = 3;
    var columnWidth = (MediaQuery.of(context).size.width - 24) / columnNum;
    var columnHeight = 80.0;

    return GetX<NewsListController>(
      init: NewsListController(widget.id, widget.hasBanner),
      global: false,
      builder: (controller) {
        return Stack(
          children: [
            widget.hasBanner
                ? EasyRefresh(
                    scrollController: _scrollController,
                    header: BallPulseHeader(enableHapticFeedback: false),
                    footer: BallPulseFooter(enableHapticFeedback: false),
                    onRefresh: controller.refresh,
                    onLoad: controller.loadData,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          AppBanner(
                            items: controller.bannerList
                                .map<Widget>(
                                  (i) => BannerImageItem(
                                    pic: i.pic_url,
                                    title: _htmlUnescape.convert(i.title ?? ""),
                                    onTaped: () => PageNavigator.toNewsDetail(
                                      id: i.object_id,
                                      url: i.object_url,
                                      title: i.title,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          newsList(
                            controller: controller,
                            columnHeight: columnHeight,
                            columnNum: columnNum,
                            columnWidth: columnWidth,
                            scrollController: _scrollController,
                          ),
                        ],
                      ),
                    ),
                  )
                : EasyRefresh(
                    header: BallPulseHeader(enableHapticFeedback: false),
                    footer: BallPulseFooter(enableHapticFeedback: false),
                    onRefresh: controller.refresh,
                    onLoad: controller.loadData,
                    child: newsList(
                      controller: controller,
                      columnHeight: columnHeight,
                      columnNum: columnNum,
                      columnWidth: columnWidth,
                    ),
                  ),
            Visibility(
              visible: controller.loading.value && controller.newsList.isEmpty,
              child: Center(child: CircularProgressIndicator()),
            ),
            Visibility(
              visible: controller.error.value,
              child: Center(
                child: AppErrorWidget(
                  controller.errorStr.value,
                  refresh: controller.loadData,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget newsList({
    required NewsListController controller,
    required int columnNum,
    required double columnWidth,
    required double columnHeight,
    ScrollController? scrollController,
  }) {
    return controller.newsList.length > 0
        ? GridView.builder(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
            controller: scrollController,
            shrinkWrap: scrollController != null,
            physics: scrollController == null ? null : ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnNum,
              childAspectRatio: columnWidth / columnHeight,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            scrollDirection: Axis.vertical,
            itemCount: controller.newsList.length,
            itemBuilder: (_, i) {
              var item = controller.newsList[i];
              return listItemBuilder(item);
            },
          )
        : Container();
  }

  Widget listItemBuilder(NewsListItemResponse item) {
    return BorderCard(
      onTap: () => PageNavigator.toNewsDetail(
        id: item.articleId,
        title: _htmlUnescape.convert(item.title),
        url: item.pageUrl,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 7.2 / 4.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Utils.createCacheImage(item.rowPicUrl, 720, 450),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _htmlUnescape.convert(item.title),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(child: Center()),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          TimelineUtil.format(
                            int.parse(item.createTime.toString()) * 1000,
                            locale: 'zh',
                          ),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        child: Icon(
                          Icons.thumb_up,
                          size: 12.0,
                          color: Colors.grey,
                        ),
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      ),
                      Text(
                        item.moodAmount.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Padding(
                        child: Icon(Icons.chat, size: 12.0, color: Colors.grey),
                        padding: EdgeInsets.fromLTRB(8, 0, 4, 0),
                      ),
                      Text(
                        item.commentAmount.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }
}
