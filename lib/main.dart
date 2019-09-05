import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
import 'package:takeaway/pages/orders_admin.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped-models/main.dart';
import './models/product.dart';
import './widgets/helpers/custom_route.dart';
import './shared/global_config.dart';
import './pages/order_list.dart';
import './providers/auth.dart';
import './providers/products.dart';
import './models/cart.dart';
import './models/order.dart';
import './pages/wallet.dart';
void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;

  MapView.setApiKey(apiKey);
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;


  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building main page');
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            builder: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.userId,
              auth.email,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
          ],
    child: ScopedModel<MainModel>(
    model: _model,

      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepOrange),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
          '/order': (BuildContext context) =>
          !_isAuthenticated ? AuthPage() : OrdersAdminPage(_model),


        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return CustomRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductsPage(_model));
        },
      ),
    )
    );
  }
}
