import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/dialog.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_permission.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/app_validator.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:iclick/features/profile/presentation/pages/resetpass.dart';

class EditProfileScreen extends StatelessWidget {
  UserModel profile;
  EditProfileScreen(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => ProfileCubit()..initEditprofile(profile),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        builder: (context, state) {
          ProfileCubit cubit = ProfileCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Components.defText(text: "Edit Profile"),
            ),
            body: state is EditProfileLoading
                ? Center(
                    child: Components.loadingwidget(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formstate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Components.sizedhg(size: 12),
                            Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  cubit.image == null
                                      ? Components.defchachedimg(
                                          Stringconstants.basicimg(profile),
                                          wid: 90,
                                          high: 90,
                                          circular: true)
                                      : Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: FileImage(cubit.image!),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                  InkWell(
                                    onTap: () => PermissionApp.storageperm(
                                        cubit.selectImage(context: context)),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: AppColors.primary,
                                      child: Icon(
                                        IconBroken.Camera,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Components.sizedhg(),
                            Row(
                              children: [
                                Expanded(
                                  child: Components.defaultform(
                                      textInputAction: TextInputAction.next,
                                      controller: cubit.firstnamecon,
                                      validator: (p0) =>
                                          AppValidator.firstnameVali(p0),
                                      hint: "First Name",
                                      focusNode: FocusNode(),
                                      fouce: false),
                                ),
                                Components.sizedwd(size: 10),
                                Expanded(
                                  child: Focus(
                                    child: Components.defaultform(
                                        textInputAction: TextInputAction.next,
                                        controller: cubit.lastnamecon,
                                        validator: (p0) =>
                                            AppValidator.lastnameVali(p0),
                                        hint: "Last Name",
                                        focusNode: FocusNode(),
                                        fouce: false),
                                  ),
                                ),
                              ],
                            ),
                            Components.sizedhg(size: 12),
                            Components.defaultform(
                                errortext: cubit.usernameused
                                    ? "Username Already Used"
                                    : null,
                                controller: cubit.usernamecon,
                                validator: (value) =>
                                    AppValidator.validateUsername(value!),
                                hint: "username",
                                focusNode: FocusNode(),
                                fouce: false),
                            Components.sizedhg(size: 12),
                            Components.defaultform(
                                controller: cubit.instagramcon,
                                validator: (value) {},
                                onChanged: (v) => cubit.refrashstate(),
                                hint: "Instagram",
                                focusNode: FocusNode(),
                                fouce: false),
                            Components.sizedhg(size: 3),
                            Components.defText(
                                text:
                                    " https://www.instagram.com/${cubit.instagramcon.text}",
                                size: 12),
                            Components.sizedhg(size: 12),
                            Components.defaultform(
                                controller: cubit.facebookcon,
                                validator: (value) {},
                                onChanged: (v) => cubit.refrashstate(),
                                hint: "Facebook",
                                focusNode: FocusNode(),
                                fouce: false),
                            Components.sizedhg(size: 3),
                            Components.defText(
                                text:
                                    " https://www.facebook.com/${cubit.facebookcon.text}",
                                size: 12),
                            Components.sizedhg(size: 12),
                            Components.defaultform(
                                controller: cubit.biocon,
                                validator: (value) {},
                                hint: "Bio",
                                maxlines: null,
                                maxLength: 101,
                                textInputType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                focusNode: FocusNode(),
                                fouce: false),
                            Components.sizedhg(),
                            Row(
                              children: [
                                Expanded(
                                    child: Components.defButton(
                                        text: "Delete Account",
                                        onTap: () {
                                          showconfrimdeleteitem(context,
                                              title: "Delete Account",
                                              desc:
                                                  "The account will be permanently deleted and cannot be retrieved again. Do you wish to delete?",
                                              onPressed: () =>
                                                  cubit.deleteaccount(context));
                                        },
                                        border: 3)),
                                Components.sizedwd(size: 5),
                                Expanded(
                                    child: Components.defButton(
                                        text: "Reset Password",
                                        onTap: () => AppRoutes.animroutepush(
                                            context: context,
                                            screen: ResetPasswordScreen()),
                                        border: 3)),
                              ],
                            ),
                            Components.sizedhg(size: 12),
                            Components.defButton(
                              text: "Save Change",
                              onTap: () {
                                if (formstate.currentState!.validate()) {
                                  if (cubit.image != null) {
                                    cubit.updateimage(context);
                                  } else {
                                    cubit.editprofile(context);
                                  }
                                }
                              },
                              border: 3,
                            )
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
