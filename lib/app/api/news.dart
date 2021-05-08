import 'dart:convert';

import 'package:flutter_dmzj/app/config_helper.dart';
import 'package:flutter_dmzj/app/http_util.dart';
import 'package:flutter_dmzj/models/news/news_banner_model.dart';
import 'package:flutter_dmzj/models/news/news_stat_detail.dart';
import 'package:flutter_dmzj/models/news/news_tag_model.dart';
import 'package:flutter_dmzj/protobuf/news/news_list_response.pb.dart';

import 'api_util.dart';

class NewsApi {
  static NewsApi? _comicApi;
  static NewsApi get instance {
    if (_comicApi == null) {
      _comicApi = NewsApi();
    }
    return _comicApi!;
  }

  /// 新闻分类
  Future<List<NewsTagItemModel>> getNewsCategores() async {
    var path = "${ApiUtil.BASE_URL_V3}/article/category.json";
    var result = await HttpUtil.instance.httpGetJson(
      path,
      queryParameters: ApiUtil.defaultParameter(),
    );

    List<NewsTagItemModel> data = [];
    for (var item in result) {
      data.add(NewsTagItemModel.fromJson(item));
    }
    return data;
  }

  //新闻数据
  Future<NewsDetailStatModel> getNewsStat(int id) async {
    var path = "${ApiUtil.BASE_URL_V3}/v3/article/total/$id.json";
    var result = await HttpUtil.instance.httpGetJson(
      path,
      queryParameters: ApiUtil.defaultParameter(),
    );

    return NewsDetailStatModel.fromJson(result["data"]);
  }

  /// 新闻Banner
  Future<List<NewsBannerItemModel>> getNewsBanner() async {
    var path = "${ApiUtil.BASE_URL_V3}/v3/article/recommend/header.json";
    var result = await HttpUtil.instance.httpGetJson(
      path,
      queryParameters: ApiUtil.defaultParameter(),
    );
    NewsBannerModel data = NewsBannerModel.fromJson(result);
    if (data.code != 0) {
      throw AppError(data.msg ?? "", code: data.code);
    }

    return data.data ?? [];
  }

  /// 新闻列表
  Future<List<NewsListItemResponse>> getNewsList(int? id,
      {int page = 1}) async {
    var path = "${ApiUtil.BASE_URL_V4}/news/list/$id/${id == 0 ? 2 : 3}/$page";
    var result = await HttpUtil.instance.httpGet(
      path,
      queryParameters: ApiUtil.defaultParameter(),
    );
    var resultBytes = ApiUtil.decrypt(result);

    var data = NewsListResponse.fromBuffer(resultBytes);
    if (data.errno != 0) {
      throw AppError(data.errmsg);
    }
    return data.data;
  }

  //检查新闻收藏
  Future<bool> checkNewsSubscribe(int newsId) async {
    if (!ConfigHelper.getUserIsLogined()) {
      return false;
    }
    var path = "https://interface.dmzj1.com/api/news/subscribe/check";
    var par = {
      'uid': int.parse(ConfigHelper.getUserInfo()?.uid ?? "0"),
      "sub_id": newsId,
    };
    var parJson = jsonEncode(par);
    var sign = ApiUtil.sign(parJson, 'app_news_sub');

    var result = await HttpUtil.instance.httpPostJson(
      path,
      data: {"parm": parJson, "sign": sign},
    );

    return jsonDecode(result)["msg"] == "您已订阅过";
  }

  //点赞新闻
  Future<bool> likeNews(int id) async {
    if (!ConfigHelper.getUserIsLogined()) {
      return false;
    }
    var path = "${ApiUtil.BASE_URL_V3}/article/mood/$id";
    var result = await HttpUtil.instance.httpGetJson(
      path,
      queryParameters: ApiUtil.defaultParameter(),
    );

    return result["code"] == 0;
  }

  //收藏新闻
  Future<bool> addNewsSubscribe(int newsId) async {
    if (!ConfigHelper.getUserIsLogined()) {
      return false;
    }
    var path = "https://interface.dmzj1.com/api/news/subscribe/add";
    var par = {
      'uid': int.parse(ConfigHelper.getUserInfo()?.uid ?? "0"),
      "sub_id": newsId,
    };
    var parJson = jsonEncode(par);
    var sign = ApiUtil.sign(parJson, 'app_news_sub');

    var result = jsonDecode(await HttpUtil.instance.httpPostJson(
      path,
      data: {"parm": parJson, "sign": sign},
    ));
    if (result["result"] == 1000) {
      return true;
    } else {
      return false;
    }
  }

  //取消收藏
  Future<bool> delNewsSubscribe(int newsId) async {
    if (!ConfigHelper.getUserIsLogined()) {
      return false;
    }
    var path = "https://interface.dmzj1.com/api/news/subscribe/del";
    var par = {
      'uid': int.parse(ConfigHelper.getUserInfo()?.uid ?? "0"),
      "sub_id": newsId,
    };
    var parJson = jsonEncode(par);
    var sign = ApiUtil.sign(parJson, 'app_news_sub');

    var result = jsonDecode(await HttpUtil.instance.httpPostJson(
      path,
      data: {"parm": parJson, "sign": sign},
    ));
    if (result["result"] == 1000) {
      return true;
    } else {
      return false;
    }
  }
}
