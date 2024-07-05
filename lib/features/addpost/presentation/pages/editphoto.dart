import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/dialog.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/addpost/presentation/cubit/addpost_cubit.dart';
import 'package:iclick/features/addpost/presentation/pages/addtext.dart';
import 'package:iclick/features/addpost/presentation/widgets/editwid.dart';
import 'package:iclick/features/addpost/data/models/dargable.dart';
import 'package:screenshot/screenshot.dart';

class EditPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddpostCubit, AddpostState>(
      builder: (context, state) {
        AddpostCubit cubit = AddpostCubit.get(context);
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: state is UploadStoryLoading || state is UploadPostLoading
              ? Center(
                  child: Components.loadingwidget(),
                )
              : Stack(
                  children: [
                    Screenshot(
                        controller: cubit.screenshotController,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(
                              image: FileImage(cubit.filee!),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black
                                    .withOpacity(cubit.opacityLayer),
                              ),
                            ),
                            Align(
                              key: UniqueKey(),
                              alignment: Alignment.center,
                              child: cubit.drag == null
                                  ? SizedBox()
                                  : Center(
                                      child: cubit.drag!,
                                    ),
                            ),
                          ],
                        )),
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
                              cubit.screenshotController
                                  .capture(
                                      delay: const Duration(milliseconds: 200))
                                  .then((value) =>
                                      cubit.saveImage(value!, context));
                            },
                            icon: MyFlutterApp.download,
                          ),
                          const SizedBox(width: 16),
                          MenuIconWidget(
                            onTap: () async {
                              cubit.screenshotController
                                  .capture(delay: Duration(milliseconds: 200))
                                  .then((value) => cubit.shareImage(value!));
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
                              Visibility(
                                visible: cubit.isopacityLayer,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Slider(
                                      value: cubit.opacityLayer,
                                      min: 0,
                                      max: 1,
                                      onChanged: (value) =>
                                          cubit.changeopacity(value),
                                    ),
                                  ),
                                ),
                              ),
                              MenuIconWidget(
                                onTap: () => cubit.offopacity(),
                                icon: Icons.layers,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          MenuIconWidget(
                            onTap: () async {
                              final result = await addText(context);
                              final widget = DragableWidget(
                                widgetId: DateTime.now().millisecondsSinceEpoch,
                                child: result,
                                onPress: (id, widget) async {
                                  if (widget is DragableWidgetTextChild) {
                                    final result = await addText(
                                      context,
                                      widget,
                                    );
                                    cubit.addtext(
                                        DragableWidget(
                                            widgetId: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            child: result),
                                        context);
                                  }
                                },
                                onLongPress: (id) async {
                                  final result = await showConfirmationDialog(
                                    context,
                                    title: "Delete Text ?",
                                    desc:
                                        "Are you sure want to Delete this text ?",
                                    rightText: "Delete",
                                  );
                                  if (result == null) return;

                                  if (result) {
                                    cubit.addtext(
                                        DragableWidget(
                                            widgetId: 0,
                                            child: DragableWidgetTextChild(
                                                text: '')),
                                        context);
                                  }
                                },
                              );
                              cubit.addtext(widget, context);
                            },
                            icon: Icons.text_fields_rounded,
                          ),
                          const SizedBox(width: 16),
                          MenuIconWidget(
                            onTap: () => cubit.cropImage(
                              context,
                            ),
                            icon: Icons.crop,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 20,
                      child: MenuIconWidget(
                        onTap: cubit.type == 0
                            ? () {
                                cubit.screenshotController
                                    .capture(
                                        delay:
                                            const Duration(milliseconds: 200))
                                    .then((value) {
                                  cubit.uploadpost(context);
                                });
                              }
                            : () async {
                                cubit.screenshotController
                                    .capture(
                                        delay:
                                            const Duration(milliseconds: 200))
                                    .then((value) {
                                  cubit.uploadStory(context, 0,
                                      imageBytes: value!);
                                });
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
