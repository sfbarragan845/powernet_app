//import 'dart:html';
// ignore_for_file: unused_local_variable

import 'dart:convert' as convert;

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class location {
  final String Api = 'AIzaSyCwLKWgJGk6_9FesKvtdmSOsJvnaLR9Vgw';
  /*Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$Api';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
    // print(json);
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$Api';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var result = json['result'] as Map<String, dynamic>;
    print(placeId);
    return result;
  }*/

  Future<Map<String, dynamic>> getDirections(String origin, String destination) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$Api&mode=driving';
    final String urlbuena = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=-0.2355615,-79.1674143&key=AIzaSyCwLKWgJGk6_9FesKvtdmSOsJvnaLR9Vgw';
    final String urltranfuga =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-0.2355615,-79.1674143&key=AIzaSyCwLKWgJGk6_9FesKvtdmSOsJvnaLR9Vgw&type=meal_takeaway&rankby=distance';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints().decodePolyline(
        json['routes'][0]['overview_polyline']['points'],
      )
    };

    //print(url);

    return results;
  }

  /*Future<List<PlaceSearch>> getAutocomplete(String search) async [
    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$Api';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;

    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  ]
}
*/
}
