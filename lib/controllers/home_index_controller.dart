import 'package:flutter/material.dart';
import 'package:flutter_dmzj/views/comic/comic_home.dart';
import 'package:flutter_dmzj/views/news/news_home.dart';
import 'package:flutter_dmzj/views/novel/novel_home.dart';
import 'package:flutter_dmzj/views/user/personal_page.dart';
import 'package:get/get.dart';

class HomeIndexController extends GetxController {
  final List<Widget> pages = [
    ComicHomePage(),
    Container(),
    Container(),
    PersonalPage()
  ];
  var index = 0.obs;
  void changeIndex(int e) {
    if (e == 1 && pages[1] is Container) {
      pages[1] = NewsHomePage();
    }
    if (e == 2 && pages[2] is Container) {
      pages[2] = NovelHomePage();
    }
    index.value = e;
  }
}
