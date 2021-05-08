import 'package:get/get.dart';

class PageNavigator {
  static void toNewsDetail({
    int? id,
    String? url,
    String? title,
  }) {
    Get.toNamed("/news/detail", preventDuplicates: false, arguments: {
      "id": id ?? 0,
      "url": url ?? "",
      "title": title ?? "",
    });
  }
}
