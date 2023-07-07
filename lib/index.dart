import "package:flutter/material.dart";
import "botonera.dart";

class Index extends StatelessWidget {
  const Index({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('imagenes/board.png'),
          const Center(
            child: Botonera(),
          ),
        ],
      ),
    );
  }
}
