import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  List<LatLng> points;
  MapWidget({super.key, required this.points});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const maxMarkersCount = 5000;
  List<Marker> allMarkers = [];
  final int _sliderVal = maxMarkersCount ~/ 10;

  @override
  Widget build(BuildContext context) {
    return widget.points.length > 1
        ? Builder(
            builder: (BuildContext context) {
              return FlutterMap(
                options: MapOptions(
                  initialCenter: widget.points[1],
                  initialZoom: 15,
                  maxZoom: 19,
                ),
                children: [
                  TileLayer(
                    maxZoom: 19,
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: allMarkers.sublist(
                        0, min(allMarkers.length, _sliderVal)),
                  ),
                  PolylineLayer(cullingMargin: null, polylines: [
                    Polyline(
                      strokeWidth: 5,
                      points: widget.points,
                      color: Colors.blue,
                    )
                  ]),
                ],
              );
            },
          )
        : Container(
            color: Colors.brown[50],
          );
  }
}
