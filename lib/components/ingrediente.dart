import 'package:flutter/material.dart';
import 'package:proyecto_app/core/app_Colors.dart';

class Ingrediente extends StatefulWidget {
  final String nombreIngrediente;
  final Function(String nombre, int cantidad) onCantidadCambiada;
  final int cantidadInicial;

  const Ingrediente({
    super.key,
    required this.nombreIngrediente,
    required this.onCantidadCambiada,
    required this.cantidadInicial,
  });

  @override
  State<Ingrediente> createState() => _IngredienteState();
}

class _IngredienteState extends State<Ingrediente> {
  late int totalIngrediente;

  @override
  void initState() {
    super.initState();
    totalIngrediente = widget.cantidadInicial;
  }

  @override
  void didUpdateWidget(covariant Ingrediente oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cantidadInicial != widget.cantidadInicial) {
      totalIngrediente = widget.cantidadInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          title: Text(widget.nombreIngrediente),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    totalIngrediente++;
                    widget.onCantidadCambiada(widget.nombreIngrediente, totalIngrediente);
                  });
                },
                icon: const Icon(Icons.add),
              ),
              Text("$totalIngrediente", style: const TextStyle(fontSize: 16)),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (totalIngrediente > 0) {
                      totalIngrediente--;
                      widget.onCantidadCambiada(widget.nombreIngrediente, totalIngrediente);
                    }
                  });
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:proyecto_app/core/app_Colors.dart';

class Ingrediente extends StatefulWidget {
  final String nombreIngrediente;
  final Function(String nombre, int cantidad) onCantidadCambiada;
  final int cantidadInicial;

  const Ingrediente({
    super.key,
    required this.nombreIngrediente,
    required this.onCantidadCambiada,
    required this.cantidadInicial,
  });

  @override
  State<Ingrediente> createState() => _IngredienteState();
}

class _IngredienteState extends State<Ingrediente> {
  late int totalIngrediente;

  @override
  void initState() {
    super.initState();
    totalIngrediente = widget.cantidadInicial;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 8, left: 8, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nombreIngrediente,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        totalIngrediente++;
                        widget.onCantidadCambiada(
                          widget.nombreIngrediente,
                          totalIngrediente,
                        );
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
                Text("$totalIngrediente", style: const TextStyle(fontSize: 16)),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (totalIngrediente > 0) {
                          totalIngrediente--;
                          widget.onCantidadCambiada(
                            widget.nombreIngrediente,
                            totalIngrediente,
                          );
                        }
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/
