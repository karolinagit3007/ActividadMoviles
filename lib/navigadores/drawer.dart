import 'package:flutter/material.dart';

import '../screen/editar_Screen.dart';
import '../screen/guardar_Screen.dart';
import '../screen/listaNotas_Screen.dart';
import '../screen/eliminar_Screen.dart';

class MiDrawer extends StatelessWidget {
  const MiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1D1D1D), 
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6200EE), 
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  'Menú de Notas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.list,
              text: "Lista de Notas",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListaNotas()),
                );
              },
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.save,
              text: "Guardar Nota",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GuardarScreen()),
                );
              },
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.edit,
              text: "Editar Nota",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditarScreen(nota: {})),
                );
              },
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.delete,
              text: "Eliminar Nota",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EliminarScreen(nota: {})),
                );
              },
            ),
            const Divider(
              color: Colors.white30,
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.exit_to_app,
              text: "Cerrar sesión",
              onTap: () {
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onTap: onTap,
    );
  }
}
