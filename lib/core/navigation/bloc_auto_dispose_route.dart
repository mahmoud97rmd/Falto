import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocAutoDisposeRoute<T> extends MaterialPageRoute<T> {
  final BlocBase _bloc;

  BlocAutoDisposeRoute({
    required Widget child,
    required BlocBase bloc,
  })  : _bloc = bloc,
        super(builder: (_) => child);

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
