import 'package:fire_notes/screens/home_Screen.dart';
import 'package:fire_notes/screens/register_page.dart';  
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void _onLoginPressed() {
    String email = emailController.text;
    String password = passwordController.text;

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('La contraseña no puede estar vacía'),
      ));
      return;
    }

    LoginUser(email, password);
  }

  void LoginUser(String email, String password) {
    setState(() {
      _isLoading = true;
    });

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((userCredential) {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Bienvenido!'),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al iniciar sesión: $error'),
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
                'Iniciar sesión'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _textField(emailController, "Correo electrónico", Icons.email_outlined),
              _textField(passwordController, "Contraseña", Icons.lock_outline, obscureText: true),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _onLoginPressed,
                      child: const Text("Iniciar sesión"),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿No tienes cuenta? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Regístrate aquí",
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
