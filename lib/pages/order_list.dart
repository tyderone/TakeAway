import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math';
import './order_edit.dart';
import '../scoped-models/main.dart';
class OrderListPage extends StatefulWidget {
  final MainModel model;

  OrderListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _OrderListPageState();
  }
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  initState() {
    final data=  widget.model.fetchAndSetOrders();
    print(data);

    widget.model.fetchAndSetOrders();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectOrder(model.allOrders[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return OrderEditPage();
            },
          ),
        ).then((_) {
          model.selectOrder(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _expanded = false;
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allOrders[index].id),

              onDismissed: (DismissDirection direction) {
                print(model.allOrders[index].products);
                if (direction == DismissDirection.endToStart) {
                  model.selectOrder(model.allOrders[index].id);

                  print(model.allOrders[index].products);
                } else if (direction == DismissDirection.startToEnd) {
                  print('Swiped start to end');
                } else {
                  print('Other swiping');
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[


                   ListTile(

                    title: Text('customer Email${model.allOrders[index].email}'),
                      subtitle: Text(
                      DateFormat('dd/MM/yyyy hh:mm').format(model.allOrders[index].dateTime),
                      ),
                     trailing: IconButton(
                     icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                     onPressed: () {
                       print(model.allOrders[index].products);
                       setState(() {
                         _expanded = !_expanded;
                       });
                     },

                   ),


            ),

                  ListTile(
                    title:
                    Text('order status${model.allOrders[index].status}'),
                    subtitle: Text('\RP.${model.allOrders[index].amount}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                  if (_expanded)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      height: min(model.allOrders[index].products.length * 20.0 + 10, 100),
                      child: ListView(
                        children: model.allOrders[index].products
                            .map(
                              (prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prod.quantity}x \RP.${prod.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        )
                            .toList(),

                      ),
                    )

                ],
              ),
            );
          },
          itemCount: model.allOrders.length,
        );
      },
    );
  }
}

