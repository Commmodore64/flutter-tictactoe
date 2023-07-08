import 'package:flutter/material.dart';
import 'package:flutter_gato/config/config.dart';
import 'package:flutter_gato/widgets/celda.dart';

class Botonera extends StatefulWidget {
  const Botonera({Key? key}) : super(key: key);

  @override
  State<Botonera> createState() => BotoneraState();
}

class BotoneraState extends State<Botonera> {
  List<EstadosCelda> estados = List.filled(9, EstadosCelda.empty);
  int xGanadas = 0;
  int oGanadas = 0;
  EstadosCelda estadoInicial = EstadosCelda.cross;
  bool esEmpate = false;

  @override
  Widget build(BuildContext context) {
    final double dimension = MediaQuery.of(context).size.width * 0.8;
    final double ancho = dimension / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego del Gato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('X Ganadas: $xGanadas'),
              const SizedBox(width: 16),
              Text('O Ganadas: $oGanadas'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: dimension,
            height: dimension,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return Celda(
                  ancho: ancho,
                  alto: ancho,
                  estado: estados[index],
                  callback: () => onPress(index),
                );
              }),
            ),
          ),
          if (esEmpate)
            const Text(
              '¡Empate!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  void onPress(int index) {
    debugPrint('Clicked $index');
    if (estados[index] == EstadosCelda.empty && !esEmpate) {
      setState(() {
        estados[index] = estadoInicial;
      });
      estadoInicial = estadoInicial == EstadosCelda.cross
          ? EstadosCelda.circle
          : EstadosCelda.cross;

      buscarGanador();
    }
  }

  void buscarGanador() {
    void sonIguales(int a, int b, int c) {
      if (estados[a] != EstadosCelda.empty) {
        if (estados[a] == estados[b] && estados[b] == estados[c]) {
          showResultDialog(estados[a]);
        } else if (!estados.contains(EstadosCelda.empty)) {
          showEmpateDialog();
        }
      }
    }

    for (int i = 0; i < estados.length; i += 3) {
      sonIguales(i, i + 1, i + 2);
    }
    for (int i = 0; i < 3; i++) {
      sonIguales(i, i + 3, i + 6);
    }
    sonIguales(0, 4, 8);
    sonIguales(2, 4, 6);
  }

  void showResultDialog(EstadosCelda ganador) {
    String mensaje;
    if (ganador == EstadosCelda.circle) {
      oGanadas++;
      mensaje = '¡Ha ganado O!';
    } else if (ganador == EstadosCelda.cross) {
      xGanadas++;
      mensaje = '¡Ha ganado X!';
    } else {
      mensaje = '¡Empate!';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado'),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text('Continuar'),
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmpateDialog() {
    setState(() {
      esEmpate = true;
    });
  }

  void resetGame() {
    setState(() {
      estadoInicial = EstadosCelda.cross;
      estados = List.filled(9, EstadosCelda.empty);
      esEmpate = false;
    });
  }
}

class Index extends StatelessWidget {
  const Index({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego del Gato'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Salir') {
                Navigator.of(context).pop();
              } else if (value == 'Reiniciar') {
                BotoneraState? botoneraState =
                    context.findAncestorStateOfType<BotoneraState>();
                if (botoneraState != null) {
                  botoneraState.resetGame();
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Salir',
                child: Text('Salir de la app'),
              ),
              const PopupMenuItem<String>(
                value: 'Reiniciar',
                child: Text('Reiniciar'),
              ),
            ],
          ),
        ],
      ),
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
