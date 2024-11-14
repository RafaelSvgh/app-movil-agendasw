import 'dart:convert';
import 'package:app_movil/src/models/estudiante.dart';
import 'package:app_movil/src/models/trivia.dart';
import 'package:app_movil/src/services/estudiante_services.dart';
import 'package:app_movil/src/services/ia_services.dart';
import 'package:app_movil/src/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TriviaPage extends ConsumerStatefulWidget {
  const TriviaPage({super.key});

  @override
  TriviaPageState createState() => TriviaPageState();
}

class TriviaPageState extends ConsumerState<TriviaPage> {
  int index = 0;
  late Trivias trivias;
  bool _isLoading = false; // Se inicia sin estar cargando
  double bar = 0.2;
  int aciertos = 0; // Variable para contar los aciertos
  int errores = 0; // Variable para contar los errores
  int? opcionSeleccionada; // para almacenar la opción seleccionada
  bool _hasStarted = false; // Controla si el juego ha comenzado
  EstudianteServices estudianteServices = EstudianteServices();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getTrivia() async {
    setState(() {
      _isLoading = true; // Inicia la carga
    });
    final user = ref.watch(userProvider);
    final response = await obtenerTrivia('titulo', 'detalle', user.edad);
    final parsed = jsonDecode(response);
    final est = await estudianteServices.estudiante(userId: user.uid);
    Estudiante estudiante = Estudiante.fromJson(est);
    ref.read(estudianteProvider.notifier).update((state) => estudiante);
    trivias = Trivias.fromJson(parsed);
    setState(() {
      _isLoading = false; // Termina la carga
    });
  }

  Future<void> refrescarPagina() async {
    await getTrivia();
  }

  void checkAnswer(int selectedIdx) {
    String correcto = trivias.trivia[index].respuestaCorrecta;
    bool isCorrect = trivias.trivia[index].opciones[selectedIdx] == correcto;

    setState(() {
      opcionSeleccionada = selectedIdx; // Asigna la opción seleccionada
      bar =
          (index + 1) / trivias.trivia.length; // Actualiza la barra de progreso
      if (isCorrect) {
        aciertos++; // Incrementa aciertos si es correcta
      } else {
        errores++; // Incrementa errores si es incorrecta
      }
    });

    // Espera un momento y luego pasa a la siguiente pregunta
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (index < trivias.trivia.length - 1) {
          index++; // Incrementa el índice para pasar a la siguiente pregunta
          opcionSeleccionada =
              null; // Resetea la opción seleccionada para la siguiente pregunta
        } else {
          // Si llegamos a la última pregunta, muestra el AlertDialog con aciertos y errores

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "¡Felicidades!",
                  textAlign: TextAlign.center,
                ),
                content: Text("Has completado todas las preguntas.\n"
                    "Aciertos: $aciertos\n"
                    "Errores: $errores"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final estudiante = ref.watch(estudianteProvider);
                          await estudianteServices.actualizarPuntos(
                              id: estudiante.id,
                              puntos: estudiante.puntos + aciertos);
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blue.shade300,
      padding: const EdgeInsets.all(15),
      child: !_hasStarted
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasStarted = true; // Marca que el juego ha comenzado
                  });
                  getTrivia(); // Cargar las preguntas
                },
                child: const Text('Comienza a jugar'),
              ),
            )
          : _isLoading
              ? SpinKitCubeGrid(
                  color: Colors.grey.shade900,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: bar,
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            trivias.trivia[index].pregunta,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 19),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                          trivias.trivia[index].opciones.length,
                          (idx) => _respuesta(trivias.trivia[index], idx),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _respuesta(Trivia trivia, int idx) {
    String correcto = trivia.respuestaCorrecta;
    bool isCorrect = trivia.opciones[idx] == correcto;

    return GestureDetector(
      onTap: opcionSeleccionada == null
          ? () => checkAnswer(idx)
          : null, // Solo permite una respuesta
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: opcionSeleccionada == null
              ? Colors.white
              : (isCorrect
                  ? Colors.green
                  : (opcionSeleccionada == idx ? Colors.red : Colors.white)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            trivia.opciones[idx],
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
