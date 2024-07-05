import 'package:flutter/material.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_validator.dart';
import 'package:iclick/features/profile/presentation/cubit/profile_cubit.dart';

Widget formotp(ProfileCubit cubit, BuildContext context, ProfileState state) {
  return TextFormField(
    style: TextStyle(color: AppColors.white),
    maxLength: 6,
    controller: cubit.otpcon,
    validator: (value) => AppValidator.otpVail(value, context),
    textInputAction: TextInputAction.next,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        errorText:
            cubit.passerror ? "The Verification code is incorrect" : null,
        counterText: "",
        counterStyle: TextStyle(color: AppColors.black),
        hintText: "OTP",
        fillColor: AppColors.secblack,
        hintStyle: TextStyle(color: AppColors.white),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        suffix: cubit.timer
            ? Components.defText(
                text: "00:${cubit.start < 10 ? '0' : ""}${cubit.start}",
                fontWeight: FontWeight.bold,
                size: 16,
                color: AppColors.primary)
            : InkWell(
                onTap: state is SendOTPLoading ? null : () => cubit.sendotp(),
                child: Components.defText(
                    text: state is SendOTPLoading ? "Loading.." : "Send",
                    fontWeight: FontWeight.bold,
                    size: 16,
                    color: AppColors.primary),
              )),
  );
}
