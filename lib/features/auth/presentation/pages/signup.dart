import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/connectivity.dart';
import 'package:iclick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:iclick/features/auth/presentation/widgets/background.dart';
import 'package:iclick/features/auth/presentation/widgets/signupwid.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);
          return isOffline(
            widget: Scaffold(
                body: bgwelcome(
              widget: cubit.indexpage == 0
                  ? signupWid(
                      cubit: cubit,
                      context: context,
                      formstate: formstate,
                      state: state)
                  : verifemail(
                      cubit: cubit,
                      context: context,
                      formstate: formstate,
                      state: state),
            )),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
