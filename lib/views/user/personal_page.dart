import 'package:flutter/material.dart';
import 'package:flutter_dmzj/app/app_theme.dart';
import 'package:flutter_dmzj/app/user_info.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.asset(
                "assets/img_ucenter_def_bac.jpg",
                fit: BoxFit.cover,
                height: 240,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: 240,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).accentColor.withOpacity(1),
                      Theme.of(context).accentColor.withOpacity(0.1)
                    ],
                  ),
                ),
                child: Provider.of<AppUserInfo>(context).isLogin
                    ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("退出登录"),
                              content: Text("确定要退出登录吗?"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("取消"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("确定"),
                                  onPressed: () {
                                    Provider.of<AppUserInfo>(context,
                                            listen: false)
                                        .logout();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 64,
                              height: 64,
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage:
                                    Utils.createCachedImageProvider(
                                        Provider.of<AppUserInfo>(context)
                                            .loginInfo!
                                            .photo!),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              Provider.of<AppUserInfo>(context)
                                  .loginInfo!
                                  .nickname!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              Provider.of<AppUserInfo>(context)
                                      .userProfile
                                      ?.description ??
                                  "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : InkWell(
                        onTap: () => Navigator.pushNamed(context, "/Login"),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 64,
                              height: 64,
                              child: CircleAvatar(
                                child: Icon(Icons.account_circle),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "点击登录",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "我的",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          ListTile(
            title: Text("我的订阅"),
            leading: Icon(Ionicons.heart_outline),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Utils.openSubscribePage(context),
          ),
          ListTile(
            title: Text("浏览记录"),
            leading: Icon(Ionicons.time_outline),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Utils.openHistoryPage(context),
          ),
          ListTile(
            title: Text("我的评论"),
            leading: Icon(Ionicons.chatbox_ellipses_outline),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Utils.openMyCommentPage(context),
          ),
          ListTile(
            title: Text("我的下载"),
            leading: Icon(Ionicons.download_outline),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "设置",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          ListTile(
            title: Text("夜间模式"),
            leading: Icon(Ionicons.moon_outline),
            trailing: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                Provider.of<AppTheme>(context).themeModeName,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            onTap: () => Provider.of<AppTheme>(context, listen: false)
                .showThemeModeDialog(
              context,
            ),
          ),
          ListTile(
            title: Text("设置"),
            leading: Icon(Ionicons.settings_outline),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.pushNamed(context, "/Setting");
            },
          ),
        ],
      ),
    );
  }
}
