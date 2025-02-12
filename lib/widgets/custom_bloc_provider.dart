import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBlocProvider extends StatelessWidget {
  const CustomBlocProvider({super.key, required this.builder});

  final Widget Function(BuildContext) builder;

  static Widget provide<T extends Cubit>({
    required Widget Function(BuildContext) builder,
    required T bloc,
    Key? key,
  }) =>
      BlocProvider<T>(
        create: (context) => bloc,
        child: CustomBlocProvider(
          key: key,
          builder: builder,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
