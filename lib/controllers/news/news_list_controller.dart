import 'package:flutter_dmzj/app/api/news.dart';
import 'package:flutter_dmzj/app/http_util.dart';
import 'package:flutter_dmzj/models/news/news_banner_model.dart';
import 'package:flutter_dmzj/protobuf/news/news_list_response.pb.dart';
import 'package:get/get.dart';
import '../base_controller.dart';

class NewsListController extends BaseController {
  final int id;
  final bool hasBanner;
  NewsListController(this.id, this.hasBanner);
  var newsList = <NewsListItemResponse>[].obs;
  var bannerList = <NewsBannerItemModel>[].obs;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future loadData() async {
    try {
      if (loading.value) return;
      loading.value = true;
      error.value = false;
      if (page.value == 1 && hasBanner) {
        if (hasBanner) {
          await loadBanner();
        }
        newsList.clear();
      }
      var data = await NewsApi.instance.getNewsList(id, page: page.value);

      if (data.length != 0) {
        newsList.addAll(data);
        page++;
      }
    } catch (e) {
      error.value = true;
      errorStr.value = "加载失败了";
    } finally {
      loading.value = false;
    }
  }

  Future refresh() async {
    page.value = 1;
    await loadData();
  }

  Future loadBanner() async {
    try {
      var data = await NewsApi.instance.getNewsBanner();
      bannerList.value = data;
    } catch (e) {
      print(e);
    } finally {}
  }
}
