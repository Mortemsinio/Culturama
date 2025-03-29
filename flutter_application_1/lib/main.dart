import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido a Culturama')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => RegistroUsuario()),
              ),
              child: Text('Usuario'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => RegistroNegocio()),
              ),
              child: Text('Negocio'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistroUsuario extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  
Future<void> registrarUsuario(BuildContext context) async
 {
  final response = await http.post(
    Uri.parse('http://localhost/culturama/registrar_usuario.php'),
    body: {
      'nombre': nameController.text,
      'correo': emailController.text,
      'contraseña': passwordController.text,
    },
  );

  final jsonResponse = jsonDecode(response.body);

  // Mostrar mensaje
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(jsonResponse['message'])),
  );

  if (jsonResponse['status'] == 'success') {
    // Limpiar los campos después de registrar
    _formKey.currentState!.reset();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro Usuario Normal')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              SizedBox(height: 20),
                ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      registrarUsuario(context); // <-- Pasa el context aquí
    }
  },
  child: Text('Registrar'),
),

            ],
          ),
        ),
      ),
    );
  }
}

class RegistroNegocio extends StatefulWidget {
  @override
  _RegistroNegocioState createState() => _RegistroNegocioState();
}

class _RegistroNegocioState extends State<RegistroNegocio> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? tipoSeleccionado;

  final List<String> tipos = [
    'museo',
    'teatro',
    'galería',
    'restaurant',
    'hospedaje',
    'otro'
  ];

 Future<void> registrarNegocio() async {
  final response = await http.post(
    Uri.parse('http://localhost/culturama/registrar_negocio.php'),
    body: {
      'negocio': businessController.text,
      'correo': emailController.text,
      'telefono': phoneController.text,
      'tipo': tipoSeleccionado ?? '',
      'contraseña': passwordController.text,
    },
  );

  final jsonResponse = jsonDecode(response.body);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(jsonResponse['message'])),
  );

  if (jsonResponse['status'] == 'success') {
    _formKey.currentState!.reset();
    businessController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    setState(() {
      tipoSeleccionado = null;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro Usuario con Negocio')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: businessController,
                  decoration: InputDecoration(labelText: 'Nombre del Negocio'),
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Correo Electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Número de Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Tipo de Negocio'),
                  value: tipoSeleccionado,
                  items: tipos.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tipoSeleccionado = value;
                    });
                  },
                  validator: (value) => value == null ? 'Selecciona un tipo' : null,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      registrarNegocio();
                    }
                  },
                  child: Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}