import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_connexion_laravel/models/api_response.dart';
import 'package:flutter_connexion_laravel/models/property.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class PropertiesService {
  static const String api = 'http://127.0.0.1:8000/api';
  static const headers = {'Content-Type': 'application/json'};

  Future<APIResponse<List<Property>>> getPropertiesList() {
    return http.get(Uri.parse(api + '/appartement')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final properties = <Property>[];
        for (var item in jsonData) {
          properties.add(Property.fromJson(item));
        }
        return APIResponse<List<Property>>(
            data: properties, error: false, errorMessage: '');
      }
      List<Property> properties = [];
      return APIResponse<List<Property>>(
        error: true,
        errorMessage: 'An error occured',
        data: properties,
      );
    });
  }

  Future<APIResponse<Property>> getPropertyById(String propertyId) {
    return http
        .get(Uri.parse(api + '/appartement/' + propertyId), headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Property>(
            data: Property.fromJson(jsonData), error: false, errorMessage: '');
      }
      throw Exception('error');
    });
  }

  Future<APIResponse<bool>> createProperty(Property item) async {
    final bytes = await Io.File(item.image).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);

    return http
        .post(Uri.parse(api + '/appartement/add'),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true, error: false, errorMessage: '');
      }
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<bool>(
            data: false, error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> updateProperty(String propertyId, Property item) {
    return http
        .put(Uri.parse(api + '/appartement/modify/' + propertyId),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true, error: false, errorMessage: '');
      }
      return APIResponse<bool>(
          data: true, error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<bool>(
            data: false, error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deleteProperty(String propertyId) {
    return http
        .delete(Uri.parse(api + '/appartement/delete/' + propertyId),
            headers: headers)
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true, error: false, errorMessage: '');
      }
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<bool>(
            data: false, error: true, errorMessage: 'An error occured'));
  }
}
