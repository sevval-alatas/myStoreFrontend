import 'package:flutter/material.dart';
import 'package:mystore_frontend/screen/login.dart';
import 'package:mystore_frontend/screen/market_detay.dart';
import 'package:mystore_frontend/screen/market_list.dart';
import 'package:mystore_frontend/screen/product.dart';
import 'package:mystore_frontend/screen/register.dart';

class AppRoutes {
  static const login = '/login';
  static const String register = '/register';

  static const markets = '/markets';
  static const products = '/products';
  static const String marketDetail = '/market-detail';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case markets:
        return MaterialPageRoute(builder: (_) => const MarketListScreen());

      case products:
        final marketId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductScreen(marketId: marketId),
        );
      case AppRoutes.marketDetail:
        final marketId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MarketDetailScreen(marketId: marketId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route bulunamadı'))),
        );
    }
  }
}
