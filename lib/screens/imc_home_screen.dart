import 'package:flutter/material.dart';
import 'package:proyecto_app/components/logoImageCenter.dart';
import 'package:proyecto_app/screens/imc_pag1_screen.dart';

class ImcHomeScreen extends StatefulWidget {
  const ImcHomeScreen({super.key});

  @override
  State<ImcHomeScreen> createState() => _ImcHomeScreenState();
}

class _ImcHomeScreenState extends State<ImcHomeScreen> {
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
          Logoimagecenter(),

          SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImcPag1Screen(),
                    ),
                  );
                  print(
                    "COMANDA INICIADA",
                  ); //MUESTRA POR CONSOLAR PARA SABER SI ACTUA BIEN
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
                child: Text("INICIAR COMANDA"),
              ),
            ),
          ),

          Spacer(),

          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(127, 255, 243, 174),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // También aquí, por si el texto está en una subcolumna
                children: [
                  Text(
                    "Dirección: Carrer d'Albert Einstein, 10, 08860 Castelldefels, Barcelona, España",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 8), // Espacio entre los textos
                  Text(
                    "Teléfono: +34 686 30 47 38",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar estiloAppBar() {
    return AppBar(
      title: Text("ANKARA BURGER"),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu_rounded))],
    );
  }
}
