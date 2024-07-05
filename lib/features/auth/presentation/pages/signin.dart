import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/connectivity.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_validator.dart';
import 'package:iclick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:iclick/features/auth/presentation/pages/forgotpass.dart';
import 'package:iclick/features/auth/presentation/pages/signup.dart';
import 'package:iclick/features/auth/presentation/widgets/background.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

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
              widget: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQueryValues(context).height -
                          MediaQueryValues(context).height / 1.5,
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQueryValues(context).height / 1.5,
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28))),
                      child: state is SignInLoading
                          ? Center(
                              child: Components.loadingwidget(),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15),
                              child: Form(
                                key: formstate,
                                child: Column(
                                  children: [
                                    Components.sizedhg(),
                                    Focus(
                                      onFocusChange: (value) {
                                        value
                                            ? cubit.unfouce(cubit.passwordfoc)
                                            : cubit.unfouce(cubit.emailfoc);
                                      },
                                      child: Components.defaultform(
                                          errortext: cubit.loginerror
                                              ? "Invalid email or password"
                                              : null,
                                          focusNode: cubit.emailfoc,
                                          controller: cubit.emailcon,
                                          fouce: cubit.emailfoc.hasFocus,
                                          validator: (_) =>
                                              AppValidator.emailVali(
                                                _,
                                              ),
                                          hint: "Email"),
                                    ),
                                    Components.sizedhg(),
                                    Components.defaultform(
                                        errortext: cubit.loginerror ? "" : null,
                                        focusNode: cubit.passwordfoc,
                                        controller: cubit.passcon,
                                        suffixIcon: cubit.visipw,
                                        suffixIcontap: () =>
                                            cubit.changeobscure(),
                                        obscureText: cubit.obscureText,
                                        validator: (_) =>
                                            AppValidator.passwordVali(
                                                _, context),
                                        fouce: cubit.passwordfoc.hasFocus,
                                        hint: "Password"),
                                    Components.sizedhg(size: 40),
                                    InkWell(
                                      onTap: () => AppRoutes.animroutepush(
                                          context: context,
                                          screen: ForgotPassScreen()),
                                      child: Components.defText(
                                          letterSpacing: 2,
                                          text: 'FORGOT PASSWORD',
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Components.sizedhg(size: 40),
                                    Components.defButton(
                                      text: "LOG IN",
                                      onTap: () {
                                        if (formstate.currentState!
                                            .validate()) {
                                          cubit.signin(context);
                                        }
                                      },
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Components.defText(
                                              text: "Don't Have Account? ",
                                              size: 18),
                                          InkWell(
                                            onTap: () =>
                                                AppRoutes.animroutepush(
                                                    context: context,
                                                    screen: SignupScreen()),
                                            child: Components.defText(
                                                text: "SIGN UP",
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
