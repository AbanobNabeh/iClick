import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_validator.dart';
import 'package:iclick/core/utils/asset_manger.dart';
import 'package:iclick/features/auth/presentation/cubit/auth_cubit.dart';

Widget signupWid(
    {required AuthCubit cubit,
    required AuthState state,
    required BuildContext context,
    required GlobalKey<FormState> formstate}) {
  return SingleChildScrollView(
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28))),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  Components.sizedhg(),
                  Row(
                    children: [
                      Expanded(
                        child: Focus(
                          onFocusChange: (value) =>
                              value ? null : cubit.unfouce(cubit.firstnamefoc),
                          child: Components.defaultform(
                              textInputAction: TextInputAction.next,
                              controller: cubit.firstnamecon,
                              validator: (p0) => AppValidator.firstnameVali(p0),
                              hint: "First Name",
                              focusNode: cubit.firstnamefoc,
                              fouce: cubit.firstnamefoc.hasFocus),
                        ),
                      ),
                      Components.sizedwd(size: 10),
                      Expanded(
                        child: Focus(
                          onFocusChange: (value) =>
                              value ? null : cubit.unfouce(cubit.lastnamefoc),
                          child: Components.defaultform(
                              textInputAction: TextInputAction.next,
                              controller: cubit.lastnamecon,
                              validator: (p0) => AppValidator.lastnameVali(p0),
                              hint: "Last Name",
                              focusNode: cubit.lastnamefoc,
                              fouce: cubit.lastnamefoc.hasFocus),
                        ),
                      ),
                    ],
                  ),
                  Components.sizedhg(),
                  Focus(
                    onFocusChange: (value) =>
                        value ? null : cubit.unfouce(cubit.emailfoc),
                    child: Components.defaultform(
                        textInputAction: TextInputAction.next,
                        focusNode: cubit.emailfoc,
                        errortext: cubit.emailused
                            ? "This Email Is Already In Use"
                            : null,
                        controller: cubit.emailcon,
                        fouce: cubit.emailfoc.hasFocus,
                        validator: (_) => AppValidator.emailVali(
                              _,
                            ),
                        hint: "Email"),
                  ),
                  Components.sizedhg(),
                  Focus(
                    onFocusChange: (value) =>
                        value ? null : cubit.unfouce(cubit.passwordfoc),
                    child: Components.defaultform(
                        suffixIcon: cubit.visipw,
                        suffixIcontap: () => cubit.changeobscure(),
                        obscureText: cubit.obscureText,
                        focusNode: cubit.passwordfoc,
                        controller: cubit.passcon,
                        fouce: cubit.passwordfoc.hasFocus,
                        validator: (_) => AppValidator.passwordVali(_, context),
                        hint: "Password"),
                  ),
                  Components.sizedhg(),
                  Components.defaultform(
                      obscureText: cubit.obscureText,
                      handleSubmit: (p0) {
                        if (formstate.currentState!.validate()) {
                          cubit.verifymail();
                        }
                      },
                      focusNode: cubit.confrimpassfoc,
                      controller: cubit.confrimpasscon,
                      fouce: cubit.confrimpassfoc.hasFocus,
                      validator: (_) => AppValidator.confrimpassVali(
                          _, context, cubit.passcon.text),
                      hint: "Confirm Password"),
                  Components.sizedhg(size: 40),
                  Components.defButton(
                    isloading: state is VerifyEmailLoading,
                    text: "SIGN UP",
                    onTap: () {
                      if (formstate.currentState!.validate()) {
                        cubit.verifymail();
                      }
                    },
                  ),
                  Components.sizedhg(size: 7),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Components.defText(
                        text: "Back To Login",
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget verifemail(
    {required AuthCubit cubit,
    required BuildContext context,
    required AuthState state,
    required GlobalKey<FormState> formstate}) {
  return SingleChildScrollView(
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Form(
            key: formstate,
            child: state is SignUpLoading
                ? Center(
                    child: Components.loadingwidget(),
                  )
                : Column(
                    children: [
                      Components.sizedhg(),
                      Components.defText(
                          text: 'VERIFICATION',
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.3),
                      Components.sizedhg(),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.secblack),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Components.defText(
                              color: AppColors.white,
                              text:
                                  'A message with verification code was sent to your Email',
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Components.sizedhg(),
                      Components.defaultform(
                          errortext:
                              cubit.otperror ? "The code is invalid" : null,
                          textInputAction: TextInputAction.go,
                          maxLength: 6,
                          textInputType: TextInputType.number,
                          controller: cubit.OTPcon,
                          handleSubmit: (p0) {
                            if (formstate.currentState!.validate()) {
                              cubit.signup(context);
                            }
                          },
                          validator: (p0) => AppValidator.otpVail(p0, context),
                          hint: "Type Verification Code",
                          focusNode: cubit.OTPfoc,
                          fouce: cubit.OTPfoc.hasFocus),
                      Components.sizedhg(),
                      Components.defButton(
                          onTap: () {
                            if (formstate.currentState!.validate()) {
                              cubit.signup(context);
                            }
                          },
                          text: "VERIFY"),
                      Components.sizedhg(size: 8),
                      InkWell(
                        onTap: () => cubit.changemail(),
                        child: Components.defText(
                          text: 'Change Email',
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Image.asset(IMGManger.group),
                      Components.sizedhg(),
                    ],
                  ),
          ),
        ),
      ),
    ],
  ));
}
