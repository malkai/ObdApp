import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obd_app_mobicrowd/widgets/textWidget.dart';

import '../dataBaseClass/confSimu.dart';

class Confwidget extends StatefulWidget {
  const Confwidget({Key? key}) : super(key: key);

  @override
  State<Confwidget> createState() => _ConfwidgetState();
}

class _ConfwidgetState extends State<Confwidget> {
  late Box confapp;
  Confdata confdata = Confdata(
      rpmmin: 750,
      rpmmax: 10000,
      velomin: 0,
      velomax: 120,
      templamin: 90,
      templamax: 104.4,
      pressmin: 14.7,
      pressmax: 101,
      vin: '1GBJC34R9XF017297',
      tempaemin: 30,
      tempaemax: 70,
      mafmin: 400,
      mafmax: 1000,
      percentmin: 50,
      percentmax: 70,
      on: false);

  void init() async {
    confapp = await Hive.openBox<Confdata>('conf');
    setState(() {
      confdata = confapp.getAt(0);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void updateconf() async {
    confapp = await Hive.openBox<Confdata>('conf');
    confapp.putAt(0, confdata);
  }

  @override
  void dispose() {
    super.dispose();
    updateconf();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[50],
      height: 1000,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      //boxShadow: themeProvider.themeMode().shadow,
                    ),
                    width: 370,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Text('Simulador OBD')),
                                Switch(
                                    value: confdata.on,
                                    onChanged: (value) {
                                      setState(() {
                                        confdata.on = value;
                                      });
                                    }),
                              ],
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text('Velocidade KM/H')),
                            RangeSlider(
                              values: RangeValues(confdata.velomin.toDouble(),
                                  confdata.velomax.toDouble()),
                              min: 0,
                              max: 200,
                              divisions: 200,
                              labels: RangeLabels(
                                confdata.velomin.round().toString(),
                                confdata.velomax.round().toString(),
                              ),
                              onChanged: (values) => setState(
                                () {
                                  confdata.velomin = values.start.toInt();
                                  confdata.velomax = values.end.toInt();
                                },
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text('RPM')),
                            RangeSlider(
                              values: RangeValues(confdata.rpmmin.toDouble(),
                                  confdata.rpmmax.toDouble()),
                              min: 750,
                              max: 10000,
                              divisions: 9350,
                              labels: RangeLabels(
                                confdata.rpmmin.round().toString(),
                                confdata.rpmmax.round().toString(),
                              ),
                              onChanged: (values) => setState(
                                () {
                                  confdata.rpmmin = values.start;
                                  confdata.rpmmax = values.end;
                                },
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text(
                                    'Temperatura do liquido de arrefecimento')),
                            RangeSlider(
                              values: RangeValues(
                                  confdata.templamin, confdata.templamax),
                              min: 90,
                              max: 104.4,
                              divisions: 104 - 90,
                              labels: RangeLabels(
                                confdata.templamin.round().toString(),
                                confdata.templamax.round().toString(),
                              ),
                              onChanged: (values) => setState(
                                () {
                                  confdata.templamin = values.start;
                                  confdata.templamax = values.end;
                                },
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text(
                                    'Pressão absoluta do coletor de admissão')),
                            RangeSlider(
                              values: RangeValues(
                                  confdata.pressmin, confdata.pressmax),
                              min: 14.7,
                              max: 101,
                              divisions: 101 - 14,
                              labels: RangeLabels(
                                confdata.pressmin.round().toString(),
                                confdata.pressmax.round().toString(),
                              ),
                              onChanged: (values) => setState(
                                () {
                                  confdata.pressmin = values.start;
                                  confdata.pressmax = values.end;
                                },
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text('Temperatura do ar de entrada')),
                            RangeSlider(
                              values: RangeValues(
                                  confdata.tempaemin, confdata.tempaemax),
                              min: 30,
                              max: 70,
                              divisions: 70 - 30,
                              labels: RangeLabels(
                                confdata.tempaemin.round().toString(),
                                confdata.tempaemax.round().toString(),
                              ),
                              onChanged: (values) => setState(
                                () {
                                  confdata.tempaemin = values.start;
                                  confdata.tempaemax = values.end;
                                },
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text('Nivel de combustivel')),
                            RangeSlider(
                              values: RangeValues(
                                  confdata.percentmin.toDouble(),
                                  confdata.percentmax.toDouble()),
                              min: 0,
                              max: 100,
                              divisions: 100,
                              labels: RangeLabels(
                                confdata.percentmin.round().toString(),
                                confdata.percentmax.round().toString(),
                              ),
                              onChanged: (values) => setState(
                                () {
                                  confdata.percentmin = values.start.toInt();
                                  confdata.percentmax = values.end.toInt();
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  onPressed: () {
                                    updateconf();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
