import "package:flutter/cupertino.dart";
import "package:flutter_gato/config/config.dart";

class Celda extends StatelessWidget {
  final double? ancho, alto;
  final EstadosCelda? estado;
  final Function()? callback;
  const Celda({super.key, this.ancho, this.alto, this.estado, this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      height: ancho,
      child: CupertinoButton(onPressed: callback, child: objeto()!),
    );
  }

  Widget? objeto() {
    if (estado == EstadosCelda.empty) {
      return SizedBox(
        width: ancho,
        height: alto,
      );
    }
    if (estado == EstadosCelda.cross) return Image.asset('imagenes/x.png');
    if (estado == EstadosCelda.circle) return Image.asset('imagenes/o.png');

    return null;
  }
}
