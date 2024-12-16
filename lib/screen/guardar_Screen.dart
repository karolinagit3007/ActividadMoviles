import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GuardarScreen extends StatelessWidget {
  const GuardarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          title: const Text(
            "Guardar Nota",
            style: TextStyle(color: Colors.white), 
          ),
          shadowColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          iconTheme: const IconThemeData(
            color: Colors.white, 
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), 
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
        ),
        body: FormularioNota(),
      ),
    );
  }
}

class FormularioNota extends StatelessWidget {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Agregar una nueva nota",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _textField(_tituloController, "Título", Icons.title),
            const SizedBox(height: 15),
            _textField(_descripcionController, "Descripción", Icons.description),
            const SizedBox(height: 15),
            _textField(_precioController, "Precio", Icons.monetization_on,
                keyboardType: TextInputType.numberWithOptions()),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => guardarNota(
                _tituloController.text,
                _descripcionController.text,
                _precioController.text,
              ),
              child: const Text(
                "Guardar Nota",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> guardarNota(
      String titulo, String descripcion, String precio) async {
    if (titulo.isEmpty || descripcion.isEmpty || precio.isEmpty) {
      print("Por favor ingresa todos los campos.");
      return;
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref("notas").push();
    await ref.set({
      "titulo": titulo,
      "descripcion": descripcion,
      "precio": precio,
      "fecha": DateTime.now().toIso8601String(),
    });
  }
}
