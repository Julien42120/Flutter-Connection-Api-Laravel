// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_connexion_laravel/models/property.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_connexion_laravel/models/api_response.dart';
import 'package:flutter_connexion_laravel/services/property_service.dart';
import 'package:flutter_connexion_laravel/views/property_create.dart';
import 'package:flutter_connexion_laravel/views/property_delete.dart';

class PropertyList extends StatefulWidget {
  @override
  _PropertyListState createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  PropertiesService get service => GetIt.I<PropertiesService>();

  late APIResponse<List<Property>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchProperties();
    super.initState();
  }

  _fetchProperties() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getPropertiesList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green, title: const Text('Property list')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => PropertyCreate.empty()))
              .then((_) {
            _fetchProperties();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return const CircularProgressIndicator();
          }
          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }
          return ListView.separated(
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data[index].id),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => const PropertyDelete(),
                  );
                  if (result) {
                    final deleteResult = await service
                        .deleteProperty(_apiResponse.data[index].id.toString());
                    var message = "";
                    if (deleteResult != null && deleteResult.data == true) {
                      message = 'The note was deleted successfuly';
                    } else {
                      message != deleteResult.errorMessage;
                    }
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text('Done'),
                              content: Text(message),
                              actions: <Widget>[
                                FlatButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            ));
                    return deleteResult.data;
                  }
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.only(left: 16),
                  child: const Align(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                child: ListTile(
                  title: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        _apiResponse.data[index].title,
                        style:
                            const TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ),
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              const Text(
                                'Address : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_apiResponse.data[index].address),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          width: 170,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Postcode : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(_apiResponse.data[index].postcode),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'City : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(_apiResponse.data[index].city),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              const Text(
                                'Price : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _apiResponse.data[index].price.toString() +
                                    ' €',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 70,
                          child: Image.network(_apiResponse.data[index].image),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (_) => PropertyCreate(
                            propertyId: _apiResponse.data[index].id.toString()),
                      ),
                    )
                        .then((data) {
                      _fetchProperties();
                    });
                  },
                ),
              );
            },
            itemCount: _apiResponse.data.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.green),
          );
        },
      ),
    );
  }
}
