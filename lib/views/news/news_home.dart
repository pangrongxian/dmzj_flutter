import 'package:flutter/material.dart';
import 'package:flutter_dmzj/controllers/news/news_categores_controller.dart';
import 'package:flutter_dmzj/models/news/news_tag_model.dart';
import 'package:flutter_dmzj/widgets/app_error_widget.dart';
import 'package:get/get.dart';

import 'news_category_view.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage>
    with TickerProviderStateMixin {
  final controller = Get.put(NewsCategoresController());

  @override
  Widget build(BuildContext context) {
    return GetX<NewsCategoresController>(
      builder: (_) => controller.tabItems.isEmpty
          ? Stack(
              children: [
                Container(),
                Visibility(
                  visible: controller.loading.value,
                  child: Center(child: CircularProgressIndicator()),
                ),
                Visibility(
                  visible: controller.error.value,
                  child: Center(
                    child: AppErrorWidget(
                      controller.errorStr.value,
                      refresh: controller.loadCategores,
                    ),
                  ),
                ),
              ],
            )
          : DefaultTabController(
              length: controller.tabItems.length,
              child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(56),
                    child: Container(
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              labelColor:
                                  Theme.of(context).textTheme.bodyText1?.color,
                              labelStyle: TextStyle(
                                fontSize: 22,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 18,
                              ),
                              indicatorColor: Colors.transparent,
                              isScrollable: true,
                              tabs: controller.tabItems
                                  .map((x) => Tab(child: Text(x.tag_name!)))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: controller.tabItems
                        .map((x) => NewsCategoryView(
                              x.tag_id ?? 0,
                              hasBanner: x.tag_id == 0,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
