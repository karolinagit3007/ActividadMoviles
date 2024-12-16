import 'package:fire_notes/screens/home_Screen.dart';
import 'package:fire_notes/screens/login_page.dart';  
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isLoading = false;

  void _onRegisterPressed() {
    String email = emailController.text;
    String password = passwordController.text;
    String fullName = fullNameController.text;
    String phone = phoneController.text;

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('La contraseña no puede estar vacía'),
      ));
      return;
    }

    RegisterUser(email, password, fullName, phone);
  }

  void RegisterUser(String email, String password, String fullName, String phone) {
    setState(() {
      _isLoading = true;
    });

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((userCredential) {

      String uid = userCredential.user!.uid;

      FirebaseDatabase.instance.ref("users/$uid").set({
        'email': email,
        'fullName': fullName,
        'phone': phone,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registro exitoso. Bienvenido!'),
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar los datos: $error'),
        ));
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al crear el usuario: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Regístrate'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _textField(emailController, "Correo electrónico", Icons.email_outlined),
              _textField(passwordController, "Contraseña", Icons.lock_outline, obscureText: true),
              _textField(fullNameController, "Nombre completo", Icons.person_outline),
              _textField(phoneController, "Teléfono", Icons.phone_outlined),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _onRegisterPressed,
                      child: const Text("Registrarse"),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿Ya tienes una cuenta? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Inicia sesión aquí",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint, IconData icon,
      {bool obscureText = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
