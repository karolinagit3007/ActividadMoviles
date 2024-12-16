import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EliminarScreen extends StatefulWidget {
  final dynamic nota;  

  const EliminarScreen({required this.nota});

  @override
  _EliminarScreenState createState() => _EliminarScreenState();
}

class _EliminarScreenState extends State<EliminarScreen> {
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

  void _showDeleteConfirmationDialog(Map<dynamic, dynamic> nota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que deseas eliminar esta nota?', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          content: const Text('Esta acción no se puede deshacer.', style: TextStyle(color: Color.fromARGB(255, 11, 2, 63))),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                _deleteNota(nota); 
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNota(Map<dynamic, dynamic> nota) async {
    final key = nota['key'];
    if (key != null) {
      await _notesRef.child(key).remove();
      setState(() {
        _notas.removeWhere((element) => element['key'] == key);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eliminar Nota", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () {
            Navigator.of(context).pop(); 
          },
        ),
      ),
      body: Container(
        color: Colors.black, 
        child: _notas.isEmpty
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _showDeleteConfirmationDialog(nota), 
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
