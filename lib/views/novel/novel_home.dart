import 'package:flutter/material.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:flutter_dmzj/views/novel/novel_category.dart';
import 'package:flutter_dmzj/views/novel/novel_rank.dart';
import 'package:flutter_dmzj/views/novel/novel_recommend.dart';
import 'package:flutter_dmzj/views/novel/novel_search.dart';
import 'package:flutter_dmzj/views/novel/novel_update.dart';

class NovelHomePage extends StatefulWidget {
  @override
  _NovelHomePageState createState() => _NovelHomePageState();
}

class _NovelHomePageState extends State<NovelHomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Utils.changeNovelHomeTabIndex.on<int>().listen((e) {
      _tabController.animateTo(e);
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
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).textTheme.bodyText1?.color,
                    labelStyle: TextStyle(
                      fontSize: 22,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 18,
                    ),
                    indicatorColor: Colors.transparent,
                    isScrollable: true,
                    tabs: ["推荐", "更新", "分类", "排行"]
                        .map((x) => Tab(child: Text(x)))
                        .toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: "搜索",
                  onPressed: () {
                    showSearch(
                        context: context, delegate: NovelSearchBarDelegate());
                  },
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            NovelRecommend(),
            NovelUpdatePage(),
            NovelCategoryPage(),
            NovelRankPage(),
          ],
        ),
      ),
    );
  }
}
