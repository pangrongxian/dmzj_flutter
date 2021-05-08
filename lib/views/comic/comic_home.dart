import 'package:flutter/material.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:flutter_dmzj/views/comic/comic_category.dart';
import 'package:flutter_dmzj/views/comic/comic_rank.dart';
import 'package:flutter_dmzj/views/comic/comic_recommend.dart';
import 'package:flutter_dmzj/views/comic/comic_search.dart';
import 'package:flutter_dmzj/views/comic/comic_special.dart';
import 'package:flutter_dmzj/views/comic/comic_update.dart';

class ComicHomePage extends StatefulWidget {
  @override
  _ComicHomePageState createState() => _ComicHomePageState();
}

class _ComicHomePageState extends State<ComicHomePage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    Utils.changeComicHomeTabIndex.on<int>().listen((e) {
      _tabController!.animateTo(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: Container(
              height: 56,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).textTheme.bodyText1?.color,
                      labelStyle: TextStyle(
                        fontSize: 22,
                        fontFamily: Utils.windowsFontFamily,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: Utils.windowsFontFamily,
                      ),
                      indicatorColor: Colors.transparent,
                      isScrollable: true,
                      tabs: ["推荐", "更新", "分类", "排行", "专题"]
                          .map((x) => Tab(child: Text(x)))
                          .toList(),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      tooltip: "搜索",
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: ComicSearchBarDelegate());
                        //Utils.openPage(context, 1798, 1);
                      }),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ComicRecommend(),
              ComicUpdatePage(),
              ComicCategoryPage(),
              ComicRankPage(),
              ComicSpecialPage(),
            ],
          )),
    );
  }
}
