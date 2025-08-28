import 'package:flutter/material.dart';
import 'package:proyecto_app/components/mesa.dart';
import 'package:proyecto_app/database/mesa_helper.dart';
import 'package:proyecto_app/database/pedido_helper.dart';
import 'package:proyecto_app/screens/imc_home_screen.dart';

class ImcCambioDeMesaScreen extends StatefulWidget {
  final Mesa mesaARealizarElCambio;

  const ImcCambioDeMesaScreen({super.key, required this.mesaARealizarElCambio});

  @override
  State<ImcCambioDeMesaScreen> createState() => _ImcCambioDeMesaScreenState();
}

class _ImcCambioDeMesaScreenState extends State<ImcCambioDeMesaScreen> {
  List<Mesa> listaMesas = [];
  Mesa? mesaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF000000,
      ), //Colors.black o AppColors.background
      appBar: estiloAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Alinea a la izquierda
        children: [
          
          Text("MESA A REALIZAR EL CAMBIO: Mesa ${widget.mesaARealizarElCambio.id}",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, backgroundColor: const Color.fromARGB(255, 214, 143, 61), fontSize: 20)),

          SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<Mesa>>(
              future: MesaHelper.obtenerMesas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay mesas disponibles');
                }

                listaMesas = snapshot.data!.where((mesa) => mesa.estado == 0).toList();

                return DropdownButtonFormField<Mesa>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Selecciona la mesa a cambiar",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: mesaSeleccionada,

                  items:
                      listaMesas.map((mesa) {
                        return DropdownMenuItem<Mesa>(
                          value: mesa,
                          child: Row(
                            children: [
                              Text('Mesa ${mesa.id}'),
                              const SizedBox(width: 8),

                              Icon(
                                mesa.estado == 0
                                    ? Icons.check_circle_rounded
                                    : Icons.remove_circle_rounded,
                                color:
                                    mesa.estado == 0
                                        ? Colors.green
                                        : Colors.red,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (Mesa? nuevaMesa) {
                    setState(() {
                      mesaSeleccionada = nuevaMesa;
                    });
                  },
                );
              },
            ),
          ),

          SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (mesaSeleccionada == null) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("Error"),
                            content: Text(
                              "Debe seleccionar una mesa antes de realizar el cambio.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                    );
                  } else {
                    PedidoHelper.realizarCambioDeMesa(widget.mesaARealizarElCambio.id, mesaSeleccionada!.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ImcHomeScreen(),
                      ),
                    );
                    print("CAMBIO REALIZADO");
                  }
                },

                style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder()),
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 214, 143, 61),
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                child: Text("REALIZAR CAMBIO DE MESA"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar estiloAppBar() {
    return AppBar(
      title: Text("CAMBIO DE MESA"),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [ Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Image.asset('assets/images/LogoAnkara.png', height: 75),
        ),],
    );
  }
}


//LÓGICA DEL BOTÓN.
//Si la mesa tiene un pedido activo, se puede realizar el cambio si y solo si a la mesa a la que se cambien este sin un pedido activo.
//Lo que hace en la base de datos, es cambiar en pedido el número de mesa al que tiene asignado.
//En mesa se le cambia el estado y listo!