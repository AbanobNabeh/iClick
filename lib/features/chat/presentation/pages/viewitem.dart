import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/dialog.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/addpost/presentation/widgets/editwid.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:iclick/features/profile/presentation/widgets/videoitem.dart';

class ViewItemScreen extends StatelessWidget {
  UserModel userModel;
  var file;
  String type;
  String filename;
  ViewItemScreen(this.file, this.userModel, this.type, this.filename,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Column(),
                type == 'pdf'
                    ? Center(
                        child: Container(
                          width: MediaQueryValues(context).width / 2,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.secblack,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Icon(
                                    MyFlutterApp.file_pdf,
                                    size: 24,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              Container(
                                color: AppColors.grey.withOpacity(0.5),
                                width: MediaQueryValues(context).width / 2,
                                child: Components.defText(
                                    text: filename,
                                    lines: 1,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    : type == 'video'
                        ? Center(
                            child: VideoGridItem(
                              videoUrl: file,
                              chat: true,
                            ),
                          )
                        : Center(child: Image.file(file)),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  child: MenuIconWidget(
                    onTap: () async {
                      final result = await showConfirmationDialog(
                        context,
                        title: "Discard Sned",
                        desc: "Are you sure want to Exit ?",
                      );
                      if (result) {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icons.arrow_back_ios_new_rounded,
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                  child: MenuIconWidget(
                    onTap: () => ChatCubit.get(context)
                        .uploadfile(file.path, context, type, userModel),
                    icon: Icons.send,
                  ),
                ),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is SendMessageSuccess) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
