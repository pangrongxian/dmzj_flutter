import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dmzj/app/api.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:flutter_dmzj/models/comic/comic_special_item.dart';
import 'package:flutter_dmzj/widgets/border_card.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ComicSpecialPage extends StatefulWidget {
  ComicSpecialPage({Key? key}) : super(key: key);

  @override
  _ComicSpecialPageState createState() => _ComicSpecialPageState();
}

class _ComicSpecialPageState extends State<ComicSpecialPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<ComicSpecialItem> _list = [];
  bool _loading = false;
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    var columnNum = MediaQuery.of(context).size.width ~/ 400;
    if (columnNum < 1) columnNum = 1;
    var columnWidth = (MediaQuery.of(context).size.width - 24) / columnNum;
    var textSize = Utils.calculateTextHeight(context, "测试",
        Theme.of(context).textTheme.bodyText1?.fontSize ?? 16, 1);
    var columnHeight = (columnWidth * (2.8 / 7.2)) + textSize.height + 16;

    super.build(context);
    return EasyRefresh(
      onRefresh: () async {
        _page = 0;
        await loadData();
      },
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onLoad: loadData,
      child: _list.length < 0
          ? Container()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnNum,
                childAspectRatio: columnWidth / columnHeight,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _list.length,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (cxt, i) {
                var f = _list[i];
                return BorderCard(
                  onTap: () {
                    Utils.openPage(context, f.id, 5);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Utils.createCacheImage(f.small_cover!, 710, 280),
                        SizedBox(height: 4),
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                f.title ?? "",
                                maxLines: 1,
                              )),
                              Text(
                                DateUtil.formatDate(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        f.create_time! * 1000),
                                    format: "yyyy-MM-dd"),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future loadData() async {
    try {
      if (_loading) {
        return;
      }
      setState(() {
        _loading = true;
      });
      var response = await http.get(Uri.parse(Api.comicSpecial(page: _page)));
      List jsonMap = jsonDecode(response.body)["data"];
      List<ComicSpecialItem> detail =
          jsonMap.map((i) => ComicSpecialItem.fromJson(i)).toList();
      if (detail != null) {
        setState(() {
          if (_page == 0) {
            _list = detail;
          } else {
            _list.addAll(detail);
          }
        });
        if (detail.length != 0) {
          _page++;
        } else {
          Utils.showToast(msg: "加载完毕");
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
