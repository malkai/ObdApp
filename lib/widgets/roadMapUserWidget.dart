import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  List<LatLng>? points;
  MapWidget({Key? key, required this.points}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const maxMarkersCount = 5000;
  List<Marker> allMarkers = [];
  final int _sliderVal = maxMarkersCount ~/ 10;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return FlutterMap(
        options: MapOptions(
          center: widget.points?[0],
          zoom: 13,
          maxZoom: 19,
          interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
        ),
        children: [
          TileLayer(
            maxZoom: 19,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayer(
            markers: allMarkers.sublist(0, min(allMarkers.length, _sliderVal)),
          ),
          PolylineLayer(polylineCulling: false, polylines: [
            Polyline(
              strokeWidth: 5,
              points: widget.points!,
              color: Colors.blue,
            )
          ]),
        ],
        /*
        layers: [
          TileLayerOptions(
            maxZoom: 19,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayerOptions(
              markers:
                  allMarkers.sublist(0, min(allMarkers.length, _sliderVal))),
          PolylineLayerOptions(
            polylineCulling: false,
            polylines: [
              Polyline(
                strokeWidth: 5,
                points: widget.points!,
                color: Colors.blue,
              ),
            ],
          ),
        ],*/
      );
    });
  }
}
