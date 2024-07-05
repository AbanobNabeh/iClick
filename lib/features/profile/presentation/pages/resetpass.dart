import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_validator.dart';
import 'package:iclick/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:iclick/features/profile/presentation/widgets/resetpw.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        builder: (context, state) {
          ProfileCubit cubit = ProfileCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Components.defText(text: "Reset Password"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formstate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Components.sizedhg(),
                      cubit.isOTP
                          ? formotp(cubit, context, state)
                          : Components.defaultform(
                              controller: cubit.currentpasscon,
                              errortext: cubit.passerror
                                  ? "The current password is incorrect"
                                  : null,
                              validator: (value) =>
                                  AppValidator.passwordVali(value, context),
                              hint: "Current password",
                              focusNode: FocusNode(),
                              fouce: false,
                              textInputAction: TextInputAction.next,
                              obscureText: cubit.obscureText,
                              suffixIcon: cubit.visipw,
                              suffixIcontap: () => cubit.changeobscure(),
                            ),
                      Components.sizedhg(size: 3),
                      cubit.isOTP
                          ? InkWell(
                              onTap: () => cubit.switchtootp(),
                              child: Components.defText(
                                  text: "Use Current Password instead",
                                  size: 16,
                                  color: AppColors.primary),
                            )
                          : InkWell(
                              onTap: () => cubit.switchtootp(),
                              child: Components.defText(
                                  text: "Use the verification code instead",
                                  size: 16,
                                  color: AppColors.primary),
                            ),
                      Components.sizedhg(size: 10),
                      Components.defaultform(
                        controller: cubit.newpasscon,
                        validator: (value) =>
                            AppValidator.passwordVali(value, context),
                        hint: "New Password",
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        fouce: false,
                        obscureText: cubit.obscureText,
                        suffixIcon: cubit.visipw,
                        suffixIcontap: () => cubit.changeobscure(),
                      ),
                      Components.sizedhg(size: 10),
                      Components.defaultform(
                        controller: cubit.confrimpasscon,
                        validator: (value) => AppValidator.confrimpassVali(
                            value, context, cubit.newpasscon.text),
                        hint: "Confirm password",
                        focusNode: FocusNode(),
                        fouce: false,
                        textInputAction: TextInputAction.go,
                        obscureText: cubit.obscureText,
                        suffixIcon: cubit.visipw,
                        suffixIcontap: () => cubit.changeobscure(),
                      ),
                      Components.sizedhg(),
                      Components.defButton(
                          text: "Reset Password",
                          isloading: state is ResetPasswordLoading,
                          onTap: () {
                            if (formstate.currentState!.validate()) {
                              if (cubit.isOTP) {
                                cubit.resetpwbyotp(context);
                              } else {
                                cubit.resetpw(context);
                              }
                            }
                          },
                          border: 5)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
