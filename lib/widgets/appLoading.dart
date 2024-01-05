
import 'package:hive_flutter/hive_flutter.dart';
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
    bool firstime;

    var bancoInterno = InternalDatabase();
    firstime = bancoInterno.teste();

    if (firstime) {
      await bancoInterno.init();
    } 

    await handledata();
    setState(() {});
    context.router.replace(Initialrouter());
  
  }

  Future<void> handledata() async {
    Box obdData = await Hive.openBox<Userdata>('obdData');

    var process = obdData.values
        .where((element) => element.uservehicle.userdata.processada == false);
    print(process);
    if (process.isNotEmpty) {
      
      var bancoInterno = InternalDatabase();
   
     
      bancoInterno.processingdataOBD();
    }
  }

  Future<int> verify() async {
    Box box = await Hive.openBox<UserVehicles>('uservehicledata');
    var help =
        box.values.where((user) => user.uservehicle.userdata.isOnline == false);
    return help.length;
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

