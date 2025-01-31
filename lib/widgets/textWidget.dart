import 'package:flutter/material.dart';

class Textdata extends StatelessWidget {
  final String? freq;
  final String tipo;
  final String? texto;
  const Textdata({
    super.key,
    this.freq,
    required this.tipo,
    this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        
          Text(
            tipo,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
          Text(
            texto ?? 'NULL',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
