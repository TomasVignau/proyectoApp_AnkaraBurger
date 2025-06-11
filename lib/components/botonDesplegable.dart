import 'package:flutter/material.dart';

class BotonDesplegable extends StatelessWidget {
  final String? valorSeleccionado;
  final List<String> opciones;
  final ValueChanged<String?> onChanged;
  final String? textoAyuda;

  const BotonDesplegable({
    Key? key,
    required this.valorSeleccionado,
    required this.opciones,
    required this.onChanged,
    this.textoAyuda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: valorSeleccionado,
      hint: textoAyuda != null ? Text(textoAyuda!) : null,
      isExpanded: true,
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.white,
      onChanged: onChanged,
      items: opciones.map((String valor) {
        return DropdownMenuItem<String>(
          value: valor,
          child: Text(valor),
        );
      }).toList(),
    );
  }
}
