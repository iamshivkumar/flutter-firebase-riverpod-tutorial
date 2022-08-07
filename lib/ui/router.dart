import 'package:auth_app_1/ui/auth/register_page.dart';
import 'package:auth_app_1/ui/auth/validate_phone_page.dart';
import 'package:auth_app_1/ui/items/write_item_page.dart';
import 'package:auth_app_1/ui/root.dart';
import 'package:auth_app_1/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<MaterialPageRoute> onNavigate(RouteSettings settings) {
    late final Widget selectedPage;

    switch (settings.name) {
      case SplashPage.route:
        selectedPage = const SplashPage();
        break;
      case RegisterPage.route:
        selectedPage = RegisterPage();
        break;
      case WriteItemPage.route:
        selectedPage = const WriteItemPage();
        break;
      case ValidatePhonePage.route:
        selectedPage = const ValidatePhonePage();
        break;
      default:
        selectedPage = const Root();
        break;
    }

    return MaterialPageRoute(builder: (context) => selectedPage);
  }
}
