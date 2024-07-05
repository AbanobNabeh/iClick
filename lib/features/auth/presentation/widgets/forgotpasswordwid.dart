import 'package:flutter/material.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_validator.dart';
import 'package:iclick/core/utils/asset_manger.dart';
import 'package:iclick/features/auth/presentation/cubit/auth_cubit.dart';

Widget checkamil(
    {required GlobalKey<FormState> formstate,
    required BuildContext context,
    required AuthCubit cubit,
    required AuthState state}) {
  return Form(
    key: formstate,
    child: Column(
      children: [
        Components.defText(
            text: 'TYPE YOUR EMAIL',
            color: AppColors.primary,
            fontWeight: FontWeight.w600),
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
                text: 'We will send you a code to reset your password',
                textAlign: TextAlign.center),
          ),
        ),
        Components.sizedhg(size: 30),
        Components.defaultform(
            textInputAction: TextInputAction.done,
            focusNode: cubit.emailfoc,
            errortext: cubit.emailerror
                ? "This email address is not registered with us"
                : null,
            controller: cubit.emailcon,
            fouce: cubit.emailfoc.hasFocus,
            validator: (_) => AppValidator.emailVali(
                  _,
                ),
            hint: "Email"),
        Spacer(),
        Components.defButton(
            isloading: state is ForgotPasswordLoading,
            text: "SEND",
            onTap: () {
              if (formstate.currentState!.validate()) {
                cubit.checkemail(context);
              }
            }),
        Components.sizedhg(),
        Image.asset(IMGManger.group),
        Components.sizedhg(),
      ],
    ),
  );
}

Widget resetpass(
    {required GlobalKey<FormState> formstate,
    required BuildContext context,
    required AuthCubit cubit,
    required AuthState state}) {
  return Form(
      key: formstate,
      child: Column(
        children: [
          Components.sizedhg(),
          Components.defText(
              text: 'SET NEW PASSWORD',
              color: AppColors.primary,
              fontWeight: FontWeight.w600),
          Components.sizedhg(),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.secblack,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Components.defText(
                  color: AppColors.white,
                  text: 'Type your new password',
                  textAlign: TextAlign.center),
            ),
          ),
          Components.sizedhg(size: 30),
          Components.defaultform(
              errortext: cubit.otperror ? "The code is invalid" : null,
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
                  cubit.forgotpassword(context);
                }
              },
              focusNode: cubit.confrimpassfoc,
              controller: cubit.confrimpasscon,
              fouce: cubit.confrimpassfoc.hasFocus,
              validator: (_) =>
                  AppValidator.confrimpassVali(_, context, cubit.passcon.text),
              hint: "Confirm Password"),
          Spacer(),
          Components.defButton(
              isloading: state is CheckEmailLoading,
              text: "DONE",
              onTap: () {
                if (formstate.currentState!.validate()) {
                  cubit.forgotpassword(context);
                }
              }),
          Components.sizedhg(),
          Image.asset(IMGManger.group),
        ],
      ));
}
