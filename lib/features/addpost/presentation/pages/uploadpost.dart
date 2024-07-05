import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/dialog.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/addpost/presentation/widgets/editwid.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import '../cubit/addpost_cubit.dart';

class UploadPost extends StatelessWidget {
  const UploadPost({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddpostCubit, AddpostState>(
      builder: (context, state) {
        AddpostCubit cubit = AddpostCubit.get(context);
        return Scaffold(
          body: state is UploadPostLoading
              ? Center(
                  child: Components.loadingwidget(),
                )
              : Stack(
                  children: [
                    const SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Center(
                      child: Image.memory(cubit.postimage!),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: 20,
                      child: MenuIconWidget(
                        onTap: () async {
                          final result = await showConfirmationDialog(
                            context,
                            title: "Discard Edits",
                            desc:
                                "Are you sure want to Exit ? You'll lose all the edits you've made",
                          );

                          if (result) {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icons.arrow_back_ios_new_rounded,
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 20,
                      right: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MenuIconWidget(
                            onTap: () async {
                              cubit.saveImage(cubit.postimage!, context);
                            },
                            icon: MyFlutterApp.download,
                          ),
                          const SizedBox(width: 16),
                          MenuIconWidget(
                            onTap: () async {
                              cubit.shareImage(cubit.postimage!);
                            },
                            icon: MyFlutterApp.share,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MenuIconWidget(
                                onTap: () async {
                                  var editedImage = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageEditor(
                                        image: cubit.postimage,
                                      ),
                                    ),
                                  );
                                  cubit.applyedit(editedImage);
                                },
                                icon: MyFlutterApp.edit,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 20,
                      child: MenuIconWidget(
                        onTap: () async {
                          cubit.uploadpost(context);
                        },
                        icon: Icons.send,
                      ),
                    ),
                  ],
                ),
        );
      },
      listener: (context, state) {},
    );
  }
}
