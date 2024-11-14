import 'package:app_movil/src/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EstudiantePage extends ConsumerStatefulWidget {
  const EstudiantePage({super.key});

  @override
  EstudiantePageState createState() => EstudiantePageState();
}

class EstudiantePageState extends ConsumerState<EstudiantePage> {
  @override
  void initState() {
    super.initState();
  }
  Future<void> refrescarPagina()async{
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(child: Text(ref.watch(userProvider).role),),
    );
  }
}
