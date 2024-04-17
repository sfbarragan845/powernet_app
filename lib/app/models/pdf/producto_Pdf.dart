class Productos_PDF {
  //final int num;
  final String nombre;
  final int cant;
  final int desc;
  final String precio;

  Productos_PDF({
    //required this.num,
    required this.nombre,
    required this.cant,
    required this.desc,
    required this.precio,
  });
  @override
  toString() =>
      '{"nombre":"$nombre","cantidad":"$cant","porcentaje_descuento":"$desc","precio":"$precio"}';
}