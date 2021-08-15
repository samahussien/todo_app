import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(var bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange( bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError( bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(
      bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}