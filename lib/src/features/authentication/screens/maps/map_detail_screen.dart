import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimpleMap extends StatefulWidget {
  final String organizationName; // Name of the organization
  final String location; // General location (e.g., city or address)

  SimpleMap({required this.organizationName, required this.location});

  @override
  _SimpleMapState createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
  late GoogleMapController _mapController;
  LatLng? _targetLocation;
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _fetchCoordinates(widget.location);
  }

  Future<void> _fetchCoordinates(String address) async {
    final apiKey =
        'AIzaSyCvrPV54xt8PBYX-bjIc3CY5zWERhc8pWE'; // Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          final latLng = LatLng(location['lat'], location['lng']);
          setState(() {
            _targetLocation = latLng;
            _marker = Marker(
              markerId: MarkerId('org_location'),
              position: latLng,
              infoWindow: InfoWindow(
                title: widget.organizationName,
                snippet: widget.location,
              ),
            );
          });
          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(latLng, 15.0),
          );
        } else {
          print('Geocoding failed: ${data['status']}');
        }
      } else {
        print('Error fetching coordinates: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during geocoding: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Location'),
      ),
      body: _targetLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _targetLocation!,
                zoom: 15.0,
              ),
              markers: _marker != null ? {_marker!} : {},
            ),
    );
  }
}
