import 'package:flutter/material.dart';
import '../navigadores/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, 
        title: const Text(
          "Pantalla Principal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white, 
          ),
        ),
        iconTheme:
            const IconThemeData(color: Colors.white), 
      ),
      drawer: const MiDrawer(), 
      body: Container(
        color: Colors.black, 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.note_add, 
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 40),
                const Text(
                  "¡Bienvenido a la App de Notas!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                Text(
                  "Esta aplicación te permite gestionar tus notas de forma eficiente.\n"
                  "Crea, edita y guarda tus notas en cualquier momento, de manera fácil y rápida.\n\n"
                  "Comienza a explorar todas sus funcionalidades desde el menú.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 60),
                // Botón de acción centralizado
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    foregroundColor:
                        Colors.black, 
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    "Comienza Ahora",
                    style: TextStyle(
                      color: Colors.black, 
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
