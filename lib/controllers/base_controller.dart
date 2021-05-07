import 'package:get/get.dart';

class BaseController extends GetxController {
  var loadMore = false.obs;
  var loading = false.obs;
  var error = false.obs;
  var errorStr = "".obs;

  var page = 1.obs;
  var maxPage = 1.obs;
}
