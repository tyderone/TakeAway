import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../scoped-models/main.dart';
import '../pages/orders_screen.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }


  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Manage Order'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/order');
            },

          ),
          LogoutListTile()
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Products Found!'));


        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Products();


        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }


        return RefreshIndicator(onRefresh: model.fetchProducts, child: content,) ;




      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('TakeAway'),
      ),
      body:

      _buildProductsList(),

    );

  }
}
