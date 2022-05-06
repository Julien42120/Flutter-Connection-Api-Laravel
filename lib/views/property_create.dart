// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_connexion_laravel/models/property.dart';
import 'package:flutter_connexion_laravel/services/property_service.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class PropertyCreate extends StatefulWidget {
  late String? propertyId = null;
  PropertyCreate({required this.propertyId});
  PropertyCreate.empty();

  @override
  State<PropertyCreate> createState() => _PropertyCreateState();
}

class _PropertyCreateState extends State<PropertyCreate> {
  bool get isEditing => widget.propertyId != null;

  PropertiesService get propertyServices => GetIt.instance<PropertiesService>();

  late String errorMessage;
  late Property _property;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _size = TextEditingController();
  TextEditingController _floor = TextEditingController();
  TextEditingController _image = TextEditingController();
  TextEditingController _room = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _postcode = TextEditingController();
  TextEditingController _city = TextEditingController();

  bool _isLoading = false;

  @override
  File? image;

  Future<void> getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      if (widget.propertyId != null) {
        propertyServices
            .getPropertyById(widget.propertyId as String)
            .then((response) {
          setState(() {
            _isLoading = false;
          });
          if (response.error) {
            errorMessage = response.errorMessage;
          }
          _property = response.data;
          _titleController.text = _property.title;
          _descriptionController.text = _property.description;
          _size.text = _property.size.toString();
          _floor.text = _property.floor.toString();
          _image.text = _property.image;
          _room.text = _property.room.toString();
          _price.text = _property.price.toString();
          _address.text = _property.address;
          _postcode.text = _property.postcode;
          _city.text = _property.city;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(isEditing ? 'Edit Property' : 'Create property')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: 500,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Form of Property',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Container(
                          height: 40,
                        ),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Property Title',
                          ),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Property Description',
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          maxLines: 5,
                          minLines: 1,
                        ),
                        TextField(
                          controller: _size,
                          decoration: const InputDecoration(
                            hintText: 'Property size',
                          ),
                        ),
                        TextField(
                          controller: _floor,
                          decoration: const InputDecoration(
                            hintText: 'Property floor',
                          ),
                        ),
                        TextField(
                          controller: _image,
                          decoration: const InputDecoration(
                            hintText: 'Property image',
                          ),
                        ),
                        MaterialButton(
                            color: Colors.blue,
                            child: const Text(
                                "Choisir une image dans la galerie",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold)),
                            onPressed: getImage),
                        TextField(
                          controller: _room,
                          decoration: const InputDecoration(
                            hintText: 'Property room',
                          ),
                        ),
                        TextField(
                          controller: _price,
                          decoration: const InputDecoration(
                            hintText: 'Property price',
                          ),
                        ),
                        TextField(
                          controller: _address,
                          decoration: const InputDecoration(
                            hintText: 'Property address',
                          ),
                          maxLines: 5,
                          minLines: 1,
                        ),
                        TextField(
                          controller: _postcode,
                          decoration: const InputDecoration(
                            hintText: 'Property postcode',
                          ),
                        ),
                        TextField(
                          controller: _city,
                          decoration: const InputDecoration(
                            hintText: 'Property city',
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (isEditing) {
                                setState(() {
                                  _isLoading = true;
                                });
                                final item = Property(
                                  id: int.parse(widget.propertyId as String),
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  size: int.parse(_size.text),
                                  floor: int.parse(_floor.text),
                                  image: _image.text,
                                  room: int.parse(_room.text),
                                  price: int.parse(_price.text),
                                  address: _address.text,
                                  postcode: _postcode.text,
                                  city: _city.text,
                                );
                                final result =
                                    await propertyServices.updateProperty(
                                        widget.propertyId as String, item);

                                setState(() {
                                  _isLoading = false;
                                });

                                final title = 'Done';
                                final text = result.error
                                    ? (result.errorMessage)
                                    : 'Your note was updated';

                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                ).then((data) {
                                  if (result.data) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                final item = Property(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  size: int.parse(_size.text),
                                  floor: int.parse(_floor.text),
                                  image: _image.text,
                                  room: int.parse(_room.text),
                                  price: int.parse(_price.text),
                                  address: _address.text,
                                  postcode: _postcode.text,
                                  city: _city.text,
                                );

                                final result =
                                    await propertyServices.createProperty(item);
                                setState(() {
                                  _isLoading = false;
                                });

                                const title = 'Done';
                                final text = result.error
                                    ? (result.errorMessage)
                                    : 'Your note was created';

                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(title),
                                          content: Text(text),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Ok'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        )).then((data) {
                                  if (result.data) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
