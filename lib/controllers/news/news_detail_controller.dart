import 'package:flutter_dmzj/app/api/news.dart';
import 'package:flutter_dmzj/app/config_helper.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:flutter_dmzj/controllers/base_controller.dart';
import 'package:get/get.dart';

class NewsDetailController extends BaseController {
  var moodCount = 0.obs;
  var commentCount = 0.obs;
  var newsId = 0;
  var subscribed = false.obs;
  var liked = false.obs;
  @override
  void onInit() {
    newsId = (Get.arguments as Map)["id"] ?? 0;
    liked.value = ConfigHelper.prefs.getBool("NewsLike$newsId") ?? false;
    checkNewsSubscribe();
    loadStat();
    super.onInit();
  }

  Future loadStat() async {
    try {
      if (loading.value) return;
      loading.value = true;

      var data = await NewsApi.instance.getNewsStat(newsId);
      moodCount.value = data.moodAmount ?? 0;
      commentCount.value = data.commentAmount ?? 0;
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  void addLike() async {
    try {
      if (liked.value) {
        return;
      }
      var result = await NewsApi.instance.likeNews(newsId);
      if (result) {
        ConfigHelper.prefs.setBool("NewsLike$newsId", true);
        liked.value = true;
        moodCount.value += 1;
      }
    } catch (e) {
      Utils.showToast(msg: "点赞失败");
    }
  }

  void checkNewsSubscribe() async {
    try {
      var result = await NewsApi.instance.checkNewsSubscribe(newsId);
      if (result) {
        subscribed.value = true;
      }
    } catch (e) {
      print(e);
    }
  }

  void addOrDelNewsSubscribe() async {
    try {
      var result = subscribed.value
          ? await NewsApi.instance.delNewsSubscribe(newsId)
          : await NewsApi.instance.addNewsSubscribe(newsId);
      if (result) {
        subscribed.value = !subscribed.value;
      }
    } catch (e) {
      Utils.showToast(msg: "操作失败");
    }
  }
}
