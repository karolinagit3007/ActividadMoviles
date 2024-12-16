import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditarScreen extends StatelessWidget {
  final Map<dynamic, dynamic> nota;

  const EditarScreen({super.key, required this.nota});

  @override
  Widget build(BuildContext context) {

    final TextEditingController tituloController =
        TextEditingController(text: nota['titulo']);
    final TextEditingController descripcionController =
        TextEditingController(text: nota['descripcion']);
    final TextEditingController precioController =
        TextEditingController(text: nota['precio']?.toString() ?? '');


    void _updateNota() {
      final String titulo = tituloController.text;
      final String descripcion = descripcionController.text;
      final String precioText = precioController.text;
      final double? precio = double.tryParse(precioText);

      if (titulo.isNotEmpty && descripcion.isNotEmpty && precio != null) {
        final DatabaseReference _notesRef =
            FirebaseDatabase.instance.ref('notas');
        final key = nota['key'];

        if (key != null) {
          _notesRef.child(key).update({
            'titulo': titulo,
            'descripcion': descripcion,
            'precio': precio, 
          }).then((_) {

            Navigator.of(context).pop();
          }).catchError((error) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error al actualizar la nota: $error'),
            ));
          });
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Por favor ingrese un título, descripción y precio válido')));
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,  
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () {
            Navigator.of(context).pop(); 
          },
        ),
        title: const Text(
          'Editar Nota',
          style: TextStyle(color: Colors.white), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _textField(tituloController, "Título", Icons.title),
            const SizedBox(height: 8),
            _textField(descripcionController, "Descripción", Icons.description, maxLines: 5),
            const SizedBox(height: 8),
            _textField(precioController, "Precio", Icons.attach_money, keyboardType: TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateNota,
              child: const Text('Actualizar Nota'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), 
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint, IconData icon,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
