import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dmzj/app/app_setting.dart';
import 'package:flutter_dmzj/app/config_helper.dart';
import 'package:flutter_dmzj/app/utils.dart';
import 'package:flutter_dmzj/controllers/home_index_controller.dart';
import 'package:flutter_dmzj/sql/comic_down.dart';
import 'package:flutter_dmzj/sql/comic_history.dart';
import 'package:flutter_dmzj/views/news/news_detail.dart';
import 'package:flutter_dmzj/views/settings/comic_reader_settings.dart';
import 'package:flutter_dmzj/views/settings/novel_reader_settings.dart';
import 'package:flutter_dmzj/views/user/login_page.dart';
import 'package:flutter_dmzj/views/setting_page.dart';
import 'package:flutter_dmzj/views/user/user_page.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'app/app_theme.dart';
import 'app/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //statusBarIconBrightness: Brightness.dark,
    ),
  );

  ConfigHelper.prefs = await SharedPreferences.getInstance();

  //await initDatabase();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppTheme>(create: (_) => AppTheme(), lazy: false),
      ChangeNotifierProvider<AppUserInfo>(
          create: (_) => AppUserInfo(), lazy: false),
      ChangeNotifierProvider<AppSetting>(
          create: (_) => AppSetting(), lazy: false),
    ],
    child: MyApp(),
  ));
}

Future initDatabase() async {
  var databasesPath = await getDatabasesPath();
  var db = await openDatabase(databasesPath + "/comic_history.db", version: 1,
      onCreate: (Database _db, int version) async {
    await _db.execute('''
create table $comicHistoryTable ( 
  $comicHistoryColumnComicID integer primary key not null, 
  $comicHistoryColumnChapterID integer not null,
  $comicHistoryColumnPage double not null,
  $comicHistoryMode integer not null)
''');

    await _db.execute('''
create table $comicDownloadTableName (
$comicDownloadColumnChapterID integer primary key not null,
$comicDownloadColumnChapterName text not null,
$comicDownloadColumnComicID integer not null,
$comicDownloadColumnComicName text not null,
$comicDownloadColumnStatus integer not null,
$comicDownloadColumnVolume text not null,
$comicDownloadColumnPage integer ,
$comicDownloadColumnCount integer ,
$comicDownloadColumnSavePath text ,
$comicDownloadColumnUrls text )
''');
  });

  ComicHistoryProvider.db = db;
  ComicDownloadProvider.db = db;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '动漫之家Flutter',
      theme: ThemeData(
        primarySwatch: Provider.of<AppTheme>(context).themeColor,
        fontFamily: Utils.windowsFontFamily,
      ),
      themeMode: Provider.of<AppTheme>(context).themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Provider.of<AppTheme>(context).themeColor,
        accentColor: Provider.of<AppTheme>(context).themeColor,
        fontFamily: Utils.windowsFontFamily,
      ),
      home: HomePage(),
      initialRoute: "/",
      routes: {
        "/Setting": (_) => SettingPage(),
        "/Login": (_) => LoginPage(),
        "/User": (_) => UserPage(),
        "/ComicReaderSettings": (_) => ComicReaderSettings(),
        "/NovelReaderSettings": (_) => NovelReaderSettings(),
      },
      getPages: [
        GetPage(
          name: '/',
          page: () => HomePage(),
        ),
        GetPage(
          name: '/news/detail',
          page: () => NewsDetailPage(),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(HomeIndexController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.index.value,
          children: controller.pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.index.value,
          onTap: controller.changeIndex,
          unselectedFontSize: 12,
          selectedFontSize: 12,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: "漫画",
              icon: Icon(Ionicons.home_outline),
              activeIcon: Icon(Ionicons.home),
            ),
            BottomNavigationBarItem(
              label: "新闻",
              icon: Icon(Ionicons.newspaper_outline),
              activeIcon: Icon(Ionicons.newspaper),
            ),
            BottomNavigationBarItem(
              label: "轻小说",
              icon: Icon(Ionicons.book_outline),
              activeIcon: Icon(Ionicons.book),
            ),
            BottomNavigationBarItem(
              label: "我的",
              icon: Icon(Ionicons.person_circle_outline),
              activeIcon: Icon(Ionicons.person_circle),
            ),
          ],
        ),
      ),
    );
  }
}
