import 'package:flutter/material.dart';

class QuantityTag extends StatelessWidget {
  final String quantity;

  QuantityTag(this.quantity);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        '\quantity:$quantity',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

