import 'package:flutter/material.dart';
import 'package:takeaway/models/order.dart';

import './order_edit.dart';
import './order_list.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class OrdersAdminPage extends StatelessWidget {
  final MainModel model;

  OrdersAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Manage Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),

          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Manage Orders'),
          bottom: TabBar(
            tabs: <Widget>[

              Tab(
                icon: Icon(Icons.list),
                text: 'My Orders',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ OrderListPage(model)],
        ),
      ),
    );
  }
}