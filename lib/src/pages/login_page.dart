import 'package:app_movil/src/models/user.dart';
import 'package:app_movil/src/pages/estudiante/inicio_page.dart';
import 'package:app_movil/src/pages/tutor/inicio_page.dart';
import 'package:app_movil/src/services/auth_services.dart';
import 'package:app_movil/src/services/user_provider.dart';
import 'package:app_movil/src/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  String? _errorMessage;
  SharedPreferences? _prefs;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    cargarPrefs();
    super.initState();
  }

  cargarPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7),
        ]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          _fondo(context),
          Container(
            padding: const EdgeInsets.only(top: 150.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imagenEscuela(),
                const SizedBox(
                  height: 20.0,
                ),
                _textoBienvenida(),
                const SizedBox(
                  height: 20.0,
                ),
                _cajaLogin(boxDecoration),
                const SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Positioned _fondo(BuildContext context) {
    return Positioned(
      top: -100,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 43, 150, 237),
                  Color.fromARGB(255, 143, 196, 239)
                ])),
      ),
    );
  }

  Center _textoBienvenida() {
    return const Center(
        child: Text(
      'BIENVENIDO',
      style: TextStyle(fontSize: 35.0, letterSpacing: 3.0, color: Colors.white),
    ));
  }

  Center _imagenEscuela() {
    return Center(
        child: Image.asset(
      'assets/images/escuela.png',
      height: 130,
    ));
  }

  Container _cajaLogin(BoxDecoration boxDecoration) {
    return Container(
      width: 380.0,
      height: 400.0,
      decoration: boxDecoration,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          _formLogin(),
          const SizedBox(
            height: 65.0,
          ),
          _botonIngresar(),
        ],
      ),
    );
  }

  Widget _botonIngresar() {
    return _isLoading
        ? const SpinKitPouringHourGlassRefined(
            color: Color.fromARGB(255, 88, 169, 234))
        : ElevatedButton(
            onPressed: () async {
              final isValid = _formKey.currentState!.validate();
              if (!isValid) return;
              _login();
            },
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                    Color.fromARGB(255, 88, 169, 234))),
            child: const Text(
              'Ingresar',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  height: 2.0,
                  color: Colors.white,
                  letterSpacing: 1.8),
            ));
  }

  Form _formLogin() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _formCorreo(),
            const SizedBox(
              height: 25.0,
            ),
            _formPass(),
          ],
        ));
  }

  LoginForm _formPass() {
    return LoginForm(
      label: 'Contraseña',
      hint: 'contraseña',
      icon: Icons.lock_person,
      password: true,
      onChanged: (value) => password = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese una contraseña';
        }
        if (value.length < 6) {
          return 'Mínimo 6 caracteres';
        }
        return null;
      },
    );
  }

  LoginForm _formCorreo() {
    return LoginForm(
      label: 'Correo Electrónico',
      hint: 'correo',
      icon: Icons.alternate_email,
      onChanged: (value) => email = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese un correo';
        }
        final emailRegExp = RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        );
        if (!emailRegExp.hasMatch(value)) {
          return 'Formato de correo no válido';
        }
        return null;
      },
    );
  }

  Future<void> _login() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response =
          await _authService.login(email: email, password: password);
      _prefs!.setString('session', response['session_id']);
      _prefs!.setInt('uid', response['uid']);
      _prefs!.setString('username', response['username']);
      _prefs!.setString('name', response['name']);
      _prefs!.setString('rol', response['role']);
      _prefs!.setInt('edad', response['edad']);
      User user = User.fromJson(response);
      ref.read(userProvider.notifier).update((state) => user);
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 1700));
        setState(() {
          _isLoading = false;
        });
        if (response['role'] == 'estudiante') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const InicioPageEst()),
          );
          return;
        }
        if (response['role'] == 'tutor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const InicioPageTut()),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingrese desde el sistema web')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error de autenticación. Verifica tus credenciales.';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
    }
  }
}
