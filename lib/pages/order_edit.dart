import 'dart:io';

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../widgets/form_inputs/location.dart';
import '../widgets/form_inputs/image.dart';
import '../scoped-models/main.dart';
import '../models/location_data.dart';
import '../models/order.dart';

class OrderEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrderEditPageState();
  }
}

class _OrderEditPageState extends State<OrderEditPage> {
  final Map<String, dynamic> _formData = {
    'status': null,

  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();



  Widget _buildDescriptionTextField(OrderItem order) {
    if (order == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (order != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = order.status;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Order status'),
        // initialValue: product == null ? '' : product.description,
        controller: _descriptionTextController,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and should be 10+ characters long.';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
          child: Text('Save'),
          textColor: Colors.white,
          onPressed: () => _submitForm(
              model.updateOrder,
              model.selectOrder,
              model.selectedOrderIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, OrderItem product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildDescriptionTextField(product),
              SizedBox(
                height: 10.0,
              ),

              _buildSubmitButton(),
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }



  void _submitForm(
       Function updateOrder, Function setSelectedOrder,
      [int selectedProductIndex]) {

    _formKey.currentState.save();
//    if (selectedProductIndex == -1) {
//          return null;
//    } else {
      print(_descriptionTextController.text);
      updateOrder(
        _descriptionTextController.text,

      ).then((_) => Navigator
          .pushReplacementNamed(context, '/order')
          .then((_) => setSelectedOrder(null)));
    }
 // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
        _buildPageContent(context, model.selectedOrder);
        return model.selectedOrderIndex == -1
            ? pageContent
            : Scaffold(
          appBar: AppBar(
            title: Text('Send Order Notification'),
          ),
          body: pageContent,
        );
      },
    );
  }
}
