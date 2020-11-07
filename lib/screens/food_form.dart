import 'dart:io';

import 'package:Emergency_Web/api/food_api.dart';
import 'package:Emergency_Web/model/food.dart';
import 'package:Emergency_Web/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodForm extends StatefulWidget {
  final bool isUpdating;
  final _userName;
  FoodForm(this._userName, {@required this.isUpdating});

  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Food _currentFood;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

    if (foodNotifier.currentFood != null) {
      _currentFood = foodNotifier.currentFood;
    } else {
      _currentFood = Food();
    }

    _imageUrl = _currentFood.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
        ],
      );
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentFood.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentFood.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.category = value;
      },
    );
  }

  _onFoodUploaded(Food food) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    foodNotifier.addFood(food);
    Navigator.pop(context);
  }

  _saveFood() {
//    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    print('saveFood Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadFoodAndImage(_currentFood, widget.isUpdating, _imageFile,
        _onFoodUploaded, widget._userName);

    print("name: ${_currentFood.name}");
    print("category: ${_currentFood.category}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Food Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Food" : "Create Food",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _buildNameField(),
            _buildCategoryField(),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveFood();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
