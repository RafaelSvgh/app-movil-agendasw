import 'package:app_movil/src/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<User>((ref) {
  return User(sessionId: '', uid: 0, name: '', username: '');
});
