import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fire_notes/screen/guardar_Screen.dart';
import 'package:fire_notes/screen/eliminar_Screen.dart';
import 'package:fire_notes/screen/editar_Screen.dart';

class ListaNotas extends StatefulWidget {
  const ListaNotas({super.key});

  @override
  _ListaNotasState createState() => _ListaNotasState();
}

class _ListaNotasState extends State<ListaNotas> {
  final DatabaseReference _notesRef = FirebaseDatabase.instance.ref('notas');
  List<Map<dynamic, dynamic>> _notas = [];

  @override
  void initState() {
    super.initState();
    _getNotas();
  }

  Future<void> _getNotas() async {
    _notesRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          _notas = [];
          data.forEach((key, value) {
            if (value is Map) {
              _notas.add({"key": key, ...value});
            }
          });
        });
      }
    });
  }

  void _navigateToGuardar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GuardarScreen()),
    );
  }

  void _navigateToDetail(Map<dynamic, dynamic> nota) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalleNota(nota: nota)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("Lista de Notas", style: TextStyle(color: Colors.white)),
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: _notas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                final nota = _notas[index];
                return Card(
                  color: Colors.black, 
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 1), 
                    borderRadius: BorderRadius.circular(8), 
                  ),
                  child: ListTile(
                    title: Text(
                      nota['titulo'] ?? 'Sin título',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                    subtitle: Text(
                      nota['descripcion'] ?? 'Sin descripción',
                      style: const TextStyle(color: Colors.white), 
                    ),
                    onTap: () => _navigateToDetail(nota), 
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToGuardar,
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class DetalleNota extends StatelessWidget {
  final Map<dynamic, dynamic> nota;

  const DetalleNota({super.key, required this.nota});

  void _navigateToEditar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarScreen(nota: nota)),
    );
  }

  void _navigateToEliminar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EliminarScreen(nota: nota)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("Detalle de Nota", style: TextStyle(color: Colors.white)),
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Título: ${nota['titulo'] ?? 'Sin título'}",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text("Descripción: ${nota['descripcion'] ?? 'Sin descripción'}",
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 8),
            Text("Precio: \$${nota['precio'] ?? '0'}",
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToEditar(context),
              child: const Text("Editar Nota"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateToEliminar(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, 
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Eliminar Nota"),
            ),
          ],
        ),
      ),
    );
  }
}
