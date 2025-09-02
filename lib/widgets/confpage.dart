import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/obdPlugin.dart';
import 'package:obdapp/route/autoroute.dart';

import '../dataBaseClass/confSimu.dart';

class Confwidget extends StatefulWidget {
  const Confwidget({super.key});

  @override
  State<Confwidget> createState() => _ConfwidgetState();
}

class _ConfwidgetState extends State<Confwidget> {
  var obd2 = ObdPlugin();
  late Box confapp;
  late Box userdata;
  var myController = TextEditingController(text: 'Appteste');
  var servidor = TextEditingController(text: '');
  var add = TextEditingController(text: '');
  var speed = TextEditingController(text: '1');

  wallet user= wallet(add: "", name: "");

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
      mafmin: 400.00,
      mafmax: 1000.00,
      percentmin: 50,
      percentmax: 70,
      responseobddata: [],
      name: 'Appteste',
      timereqobd: '1',
      on: false);

  void init() async {
    confapp = await Hive.openBox<Confdata>('conf');
    setState(() {
      confdata = confapp.getAt(0);
    });

    userdata = await Hive.openBox<wallet>('wallet');
    setState(() {
      user = userdata.getAt(0);
    });

    myController = TextEditingController(text: confdata.name);
    speed = TextEditingController(text: confdata.timereqobd);
    servidor = TextEditingController(text: user.site);
    add = TextEditingController(text: user.add);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void updateconf() async {
    var cont = 0;

    if (confdata.acc) {
      cont++;
    }
    if (confdata.obd) {
      cont++;
    }
    if (confdata.gps) {
      cont++;
    }

    if (cont == 0) {
      _eMyDialog("Necessario ativar uma função: \n GPS, OBD ou Acc");
    } else {
      confapp = await Hive.openBox<Confdata>('conf');
      userdata = await Hive.openBox<wallet>('wallet');

      confapp.putAt(0, confdata);
      userdata.putAt(0, user);
      confapp.close();
      _showMyDialog();
    }
  }

  @override
  void dispose() {
    super.dispose();
    updateconf();
  }

  Future<void> _eMyDialog(String erro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro no salvamento'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(erro),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TapRegion(
          onTapOutside: (tap) {
            context.router.popForced();
          },
          child: AlertDialog(
            title: const Text(''),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Configuração Salva com Sucesso'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: (const Color(0xFF26B07F)),
            heroTag: "configuration1",
            child: const Icon(
              Icons.troubleshoot,
              color: Colors.white,
            ),
            onPressed: () {
              context.router.popAndPush(Pidsdiscovery());
            },
          ),
          SizedBox(height: 30),
          FloatingActionButton(
            heroTag: "configuration2",
            backgroundColor: (const Color(0xFF26B07F)),
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              updateconf();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: const Text('Simulador OBD')),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: TextFormField(
                            controller: myController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Nome',
                            ),
                            onChanged: (values) => setState(
                              () {
                                confdata.name = myController.text;
                                user.name = myController.text;
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: TextFormField(
                            controller: speed,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Velocidade de requisição de dados',
                            ),
                            onChanged: (values) => setState(
                              () {
                                confdata.timereqobd = speed.text;
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Switch(
                                  value: user.blockchain,
                                  onChanged: (value) {
                                    setState(() {
                                      user.blockchain = value;
                                    });
                                  }),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: const Text('Conectar a Blockchain ')),
                          ],
                        ),
                        if (user.blockchain)
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFormField(
                              controller: servidor,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Servidor de envio',
                              ),
                              onChanged: (values) => setState(
                                () {
                                  user.site = servidor.text;
                                },
                              ),
                            ),
                          ),
                        if (user.blockchain)
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFormField(
                              controller: add,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Endereço',
                              ),
                              onChanged: (values) => setState(
                                () {
                                  user.add = add.text;
                                },
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            Container(
                              child: Switch(
                                  value: confdata.acc,
                                  onChanged: (value) {
                                    setState(() {
                                      confdata.acc = value;
                                    });
                                  }),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 10, 20, 10),
                                child: const Text('Ligar accelerometer ')),
                          ],
                        ),
                        if (confdata.acc)
                          Row(
                            children: [
                              Container(
                                child: Switch(
                                    value: confdata.watch,
                                    onChanged: (value) {
                                      setState(() {
                                        confdata.watch = value;
                                        confdata.phone = !confdata.phone;
                                      });
                                    }),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: const Text('  Utilizar relógio')),
                            ],
                          ),
                        if (confdata.acc)
                          Row(
                            children: [
                              Container(
                                child: Switch(
                                    value: confdata.phone,
                                    onChanged: (value) {
                                      setState(() {
                                        confdata.phone = value;
                                        confdata.watch = !confdata.watch;
                                      });
                                    }),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: const Text('  Utilizar smarthpohne')),
                            ],
                          ),
                        Row(
                          children: [
                            Container(
                              child: Switch(
                                  value: confdata.gps,
                                  onChanged: (value) {
                                    setState(() {
                                      confdata.gps = value;
                                    });
                                  }),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 10, 20, 10),
                                child: const Text('Ligar GPS ')),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Switch(
                                  value: confdata.obd,
                                  onChanged: (value) {
                                    setState(() {
                                      confdata.obd = value;
                                    });
                                  }),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 10, 20, 10),
                                child: const Text('Ligar OBD ')),
                          ],
                        ),
                        if (confdata.obd)
                          Row(
                            children: [
                              Container(
                                child: Switch(
                                    value: confdata.on,
                                    onChanged: (value) {
                                      setState(() {
                                        confdata.on = value;
                                      });
                                    }),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: const Text('  Utilizar Simulador ')),
                            ],
                          ),
                        if (confdata.on)
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Switch(
                                        value: confdata.velo,
                                        onChanged: (value) {
                                          setState(() {
                                            confdata.velo = value;
                                          });
                                        }),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: const Text('Velocidade KM/H')),
                                  ],
                                ),
                                if (confdata.velo)
                                  RangeSlider(
                                    values: RangeValues(
                                        confdata.velomin.toDouble(),
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
                                Row(
                                  children: [
                                    Switch(
                                        value: confdata.rpm,
                                        onChanged: (value) {
                                          setState(() {
                                            confdata.rpm = value;
                                          });
                                        }),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: const Text('RPM')),
                                  ],
                                ),
                                if (confdata.rpm)
                                  RangeSlider(
                                    values: RangeValues(
                                        confdata.rpmmin.toDouble(),
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
                                Row(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Switch(
                                              value: confdata.templa,
                                              onChanged: (value) {
                                                setState(() {
                                                  confdata.templa = value;
                                                });
                                              }),
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 20, 10),
                                              child: const Text(
                                                  'Temperatura do liquido de arrefecimento')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (confdata.templa)
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
                                Row(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Switch(
                                              value: confdata.press,
                                              onChanged: (value) {
                                                setState(() {
                                                  confdata.press = value;
                                                });
                                              }),
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 20, 10),
                                              child: const Text(
                                                  'Pressão absoluta do coletor de admissão')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (confdata.press)
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
                                Row(
                                  children: [
                                    Switch(
                                        value: confdata.tempa,
                                        onChanged: (value) {
                                          setState(() {
                                            confdata.tempa = value;
                                          });
                                        }),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: const Text(
                                            'Temperatura do ar de entrada')),
                                  ],
                                ),
                                if (confdata.tempa)
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
                                Row(
                                  children: [
                                    Switch(
                                        value: confdata.percent,
                                        onChanged: (value) {
                                          setState(() {
                                            confdata.percent = value;
                                          });
                                        }),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child:
                                            const Text('Nivel de combustivel')),
                                  ],
                                ),
                                if (confdata.percent)
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
                                        confdata.percentmin =
                                            values.start.toInt();
                                        confdata.percentmax =
                                            values.end.toInt();
                                      },
                                    ),
                                  ),
                                Row(
                                  children: [
                                    Switch(
                                        value: confdata.maf,
                                        onChanged: (value) {
                                          setState(() {
                                            confdata.maf = value;
                                          });
                                        }),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: const Text(
                                            'fluxo de massa de ar (MAF)')),
                                  ],
                                ),
                                if (confdata.maf)
                                  RangeSlider(
                                    values: RangeValues(
                                        confdata.mafmin, confdata.mafmax),
                                    min: 400,
                                    max: 1000,
                                    divisions: 100,
                                    labels: RangeLabels(
                                      confdata.mafmin.round().toString(),
                                      confdata.mafmax.round().toString(),
                                    ),
                                    onChanged: (values) => setState(
                                      () {
                                        confdata.mafmin = values.start;
                                        confdata.mafmax = values.end;
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
