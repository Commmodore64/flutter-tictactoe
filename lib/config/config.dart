library config.globals;

enum EstadosCelda { empty, circle, cross }

List<EstadosCelda> estados = List.filled(9, EstadosCelda.empty);

Map<EstadosCelda, bool> resultado = {
  EstadosCelda.cross: false,
  EstadosCelda.circle: false
};
