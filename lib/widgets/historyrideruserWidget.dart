import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../dataBaseClass/vehiclesUser.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/textWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoryRideUser extends StatefulWidget {
  final VoidCallback hide;
  var userlist;

  HistoryRideUser({super.key, required this.hide, required this.userlist});

  @override
  State<HistoryRideUser> createState() => _ObdDataMapState();
}

class _ObdDataMapState extends State<HistoryRideUser> {
  double heigh1 = 600;
  //late LatLng latLong = widget.userlist.vehicle.latLong[0];
  List<LatLng> lat = [];
  int a = 0;
  List<PercentData> infovalid = [];
  List<kmData> infokm = [];
  List<kmData> infokm2 = [];
  List<kmData> infokm3 = [];
  List<fuelData> infof = [];
  List<fuelData> infof2 = [];
  late UserVehicles aux;
  @override
  void initState() {
    super.initState();

    aux = widget.userlist;

    a = int.parse(
        ((widget.userlist.vehicle.points.length - 1) / 2).toStringAsFixed(0));

    for (var i in widget.userlist.vehicle.points) {
      LatLng a = LatLng(i[0], i[1]);

      lat.add(a);
    }

    print(lat);
    for (int i = 0; i < aux.vehicle.kmaccarre.length - 1; i++) {
      infokm2.add(
          kmData(aux.vehicle.kmaccarre[i], aux.vehicle.taccarr[i].toString()));

      infof.add(fuelData(
          aux.vehicle.farrk[i], aux.vehicle.fuelkf[i], aux.vehicle.taccarr[i]));
    }
    print(aux.vehicle.kmaccarrv.length);
    for (int i = 0; i < aux.vehicle.kmaccarrv.length - 1; i++) {
      infokm3.add(
          kmData(aux.vehicle.kmaccarrv[i], aux.vehicle.taccarr[i].toString()));
    }
    setState(
      () {
        lat;
        aux;
        infokm;
        infokm2;
        infokm3;
        infof;
        infof2;

        for (var y in infokm) {
          print(y.acckm);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Stack(
          children: [
            SizedBox(
              width: 400,
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(widget.userlist.vehicle.points[a][0],
                      widget.userlist.vehicle.points[a][1]),
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
                  PolylineLayer(polylines: [
                    Polyline(
                      strokeWidth: 5,
                      points: lat,
                      color: Colors.blue,
                    )
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: FloatingActionButton(
                  child: const Icon(Icons.arrow_back),
                  onPressed: () {
                    widget.hide();
                  }),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        /*
                        if (heigh1 == 220) {
                          heigh1 = 50;
                        } else {
                          heigh1 = 220;
                        }*/
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height: heigh1,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child:
                                      SfCircularChart(series: <CircularSeries>[
                                    PieSeries<PercentData, String>(
                                        dataSource: [
                                          PercentData(aux.vehicle.percentdata,
                                              'Válidos'),
                                          PercentData(
                                              100.00 - aux.vehicle.percentdata,
                                              'Inválidos')
                                        ],
                                        xValueMapper: (PercentData data, _) =>
                                            data.title,
                                        yValueMapper: (PercentData data, _) =>
                                            data.percent)
                                  ]),
                                ),
                                Textdata(
                                  tipo: 'VIN',
                                  texto: widget.userlist.vehicle.id.toString(),
                                ),
                                Textdata(
                                  tipo: 'Tempo ',
                                  texto: '${widget.userlist.vehicle.tacc} s',
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Textdata(
                                  tipo: 'Distância total por Euclidiano ',
                                  texto: widget.userlist.vehicle.kmacce
                                          .toStringAsFixed(3) +
                                      ' km',
                                ),
                                SfCartesianChart(
                                  // Initialize category axis
                                  primaryXAxis: CategoryAxis(),
                                  series: <CartesianSeries>[
                                    // Initialize line series
                                    LineSeries<kmData, String>(
                                        dataSource: infokm2,
                                        xValueMapper: (kmData data, _) =>
                                            data.time.toString(),
                                        yValueMapper: (kmData data, _) =>
                                            data.acckm),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Textdata(
                                  tipo:
                                      'Distância total pela velocidade do veículo ',
                                  texto: widget.userlist.vehicle.kmaccv
                                          .toStringAsFixed(3) +
                                      ' km',
                                ),
                                SfCartesianChart(
                                  // Initialize category axis
                                  primaryXAxis: CategoryAxis(),
                                  series: <CartesianSeries>[
                                    // Initialize line series

                                    LineSeries<kmData, String>(
                                        dataSource: infokm3,
                                        xValueMapper: (kmData data, _) =>
                                            data.time.toString(),
                                        yValueMapper: (kmData data, _) =>
                                            data.acckm),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Textdata(
                                  tipo:
                                      'consumo de combustivel pelo filtro de Kalman ',
                                ),
                                SfCartesianChart(
                                  // Initialize category axis
                                  primaryXAxis: CategoryAxis(),
                                  series: <CartesianSeries>[
                                    // Initialize line series
                                    LineSeries<fuelData, String>(
                                        dataSource: infof,
                                        xValueMapper: (fuelData data, _) =>
                                            data.time.toString(),
                                        yValueMapper: (fuelData data, _) =>
                                            data.fuel),
                                    LineSeries<fuelData, String>(
                                        dataSource: infof,
                                        xValueMapper: (fuelData data, _) =>
                                            data.time.toString(),
                                        yValueMapper: (fuelData data, _) =>
                                            data.fuelf),
                                  ],
                                ),
                              ],
                            ),
                            Textdata(
                              tipo: 'Data ',
                              texto: widget.userlist.vehicle.time.toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )

                //MyWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PercentData {
  PercentData(this.percent, this.title);
  final double percent;
  final String title;
}

class kmData {
  kmData(this.acckm, this.time);
  final double acckm;
  final String time;
}

class fuelData {
  fuelData(this.fuel, this.fuelf, this.time);
  final double fuel;
  final double fuelf;
  final double time;
}
