
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../autoroute/autoroute.gr.dart';
import '../dataBaseClass/obdRawData.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../dataBaseClass/vehiclesUser.dart';
import '../functions/InternalDatabase.dart';

class AppLoading extends StatefulWidget {
  final String text;
  const AppLoading({Key? key, this.text = ''}) : super(key: key);

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {
  void init() async {

    var bancoInterno = InternalDatabase();
    bancoInterno.init(); 
    await handledata().then((value) { 
    context.router.replace(Initialrouter());
      });

  
  
  }

  Future<void> handledata() async {
    List<int> keys=[];
    Box<Userdata> obdData = await Hive.openBox<Userdata>('obdData');
    var process = obdData.values
        .where((element) => element.uservehicle.userdata.processada == false);
    process.forEach((element) {keys.add(element.key);});
    if (process.isNotEmpty) {
      var bancoInterno = InternalDatabase();
      bancoInterno.processingdataOBD(process,keys);
    }
  }



  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(children: [
          const LinearProgressIndicator(
            color: Colors.indigo,
          ),
          Text(
            widget.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          )
        ]),
      ),
    );
  }
}

