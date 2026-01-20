import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:obdapp/route/autoroute.dart';
import 'package:obdapp/widgets/historywidgets/pathlist.dart';

class ListEventClose extends StatefulWidget {
  List<dynamic> userpath;
  ListEventClose({required this.userpath, super.key});

  @override
  State<ListEventClose> createState() => _ListEventCloseState();
}

class _ListEventCloseState extends State<ListEventClose> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 400,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.userpath.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onDoubleTap: () {
                    context.router.push(EventListPath(
                        event: widget.userpath[index], index: index));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 108 * MediaQuery.textScalerOf(context).scale(1),
                      width: 420 * MediaQuery.textScalerOf(context).scale(1),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(
                              255, 190, 190, 190), // Set the border color
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Pathlist(
                          add: widget.userpath[index].add,
                          completude: widget.userpath[index].paths.length > 0 &&
                                  double.parse(widget.userpath[index].fuel_B) !=
                                      0
                              ? double.parse(widget.userpath[index].fuel_E) /
                                  double.parse(widget.userpath[index].fuel_B)
                              : 0.0,
                          value: widget.userpath[index].value,
                          number: widget.userpath[index].id.toString(),
                          abastecimento:
                              widget.userpath[index].abastecimento.toString(),
                          date: widget.userpath[index].date.toString(),
                          Paths: widget.userpath[index].paths,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
