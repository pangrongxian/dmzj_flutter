import 'package:flutter/material.dart';
import 'package:flutter_dmzj/app/api/news.dart';
import 'package:flutter_dmzj/models/news/news_tag_model.dart';
import 'package:get/get.dart';
import '../base_controller.dart';

class NewsCategoresController extends BaseController {
  var tabItems = <NewsTagItemModel>[].obs;

  @override
  void onInit() {
    loadCategores();
    super.onInit();
  }

  Future loadCategores() async {
    try {
      if (loading.value) return;
      loading.value = true;
      error.value = false;
      var data = await NewsApi.instance.getNewsCategores();
      data.insert(0, NewsTagItemModel(tag_id: 0, tag_name: "最新"));
      tabItems.value = data;
    } catch (e) {
      error.value = true;
      errorStr.value = "加载失败了";

      print(e);
    } finally {
      loading.value = false;
    }
  }
}
