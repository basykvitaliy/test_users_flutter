import 'package:get/get.dart';
import 'package:test_users_flutter/routes/routes.dart';
import 'package:test_users_flutter/screens/detail/detail_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.detailScreen,
      page: () => DetailScreen(id: "1"),
    ),
  ];
}
