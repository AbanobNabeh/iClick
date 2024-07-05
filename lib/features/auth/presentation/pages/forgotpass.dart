import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/connectivity.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:iclick/features/auth/presentation/widgets/background.dart';
import 'package:iclick/features/auth/presentation/widgets/forgotpasswordwid.dart';

class ForgotPassScreen extends StatelessWidget {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);
          return isOffline(
            widget: Scaffold(
              body: bgwelcome(
                  widget: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQueryValues(context).height -
                          MediaQueryValues(context).height / 1.35,
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQueryValues(context).height / 1.35,
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28))),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: state is CheckEmailLoading ||
                                  state is ForgotPasswordLoading
                              ? Center(
                                  child: Components.loadingwidget(),
                                )
                              : cubit.forgotpwindex == 0
                                  ? checkamil(
                                      formstate: formstate,
                                      context: context,
                                      cubit: cubit,
                                      state: state)
                                  : resetpass(
                                      formstate: formstate,
                                      context: context,
                                      cubit: cubit,
                                      state: state)),
                    ),
                  ],
                ),
              )),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
