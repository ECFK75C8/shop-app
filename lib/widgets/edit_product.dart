import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  final String id;

  EditProductScreen(this.id);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  var _isLoading = false;

  var _existedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: null,
  );

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_imageUrlListener);

    if (widget.id != null) {
      _existedProduct =
          Provider.of<Products>(context, listen: false).findById(widget.id);
    }
    _imageUrlController.text = _existedProduct.imageUrl ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_imageUrlListener);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void _imageUrlListener() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http:') &&
              !_imageUrlController.text.startsWith('https:')) ||
          (_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_existedProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_existedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text('An error occured!'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_existedProduct.id, _existedProduct);
    }
    _isLoading = false;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _existedProduct.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _existedProduct = Product(
                          id: _existedProduct.id,
                          title: value,
                          description: _existedProduct.description,
                          price: _existedProduct.price,
                          imageUrl: _existedProduct.imageUrl,
                          isFavorite: _existedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _existedProduct.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price must be greater than 0';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _existedProduct = Product(
                          id: _existedProduct.id,
                          title: _existedProduct.title,
                          description: _existedProduct.description,
                          price: double.parse(value),
                          imageUrl: _existedProduct.imageUrl,
                          isFavorite: _existedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _existedProduct.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Description must atleast be 10 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _existedProduct = Product(
                          id: _existedProduct.id,
                          title: _existedProduct.title,
                          description: value,
                          price: _existedProduct.price,
                          imageUrl: _existedProduct.imageUrl,
                          isFavorite: _existedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Add image URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL';
                              }
                              if (!value.startsWith('http:') &&
                                  !value.startsWith('https:')) {
                                return 'Enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Enter a valid URL';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) {
                              _existedProduct = Product(
                                id: _existedProduct.id,
                                title: _existedProduct.title,
                                description: _existedProduct.description,
                                price: _existedProduct.price,
                                imageUrl: value,
                                isFavorite: _existedProduct.isFavorite,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text(
                        (_existedProduct.id == null) ? 'Save' : 'Update',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: _saveForm,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
