import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:iclick/features/chat/presentation/pages/documentview.dart';
import 'package:iclick/features/chat/presentation/pages/videoplayer.dart';
import 'package:iclick/features/chat/presentation/widgets/tabitem.dart';
import 'package:iclick/features/profile/presentation/widgets/videoitem.dart';

class MediaChatScreen extends StatelessWidget {
  String iduser;
  MediaChatScreen(this.iduser, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()..getimagemedia(iduser, context),
      child: BlocConsumer<ChatCubit, ChatState>(
        builder: (context, state) {
          ChatCubit cubit = ChatCubit.get(context);
          return DefaultTabController(
            length: 3,
            child: Builder(
              builder: (BuildContext context) {
                final TabController controller =
                    DefaultTabController.of(context)!;
                controller.addListener(() {
                  if (!controller.indexIsChanging) {
                    if (controller.index == 0) {
                      ChatCubit.get(context).getimagemedia(iduser, context);
                    } else if (controller.index == 1) {
                      ChatCubit.get(context).getvideoedia(iduser, context);
                    } else {
                      ChatCubit.get(context).getfilesmedia(iduser, context);
                    }
                  }
                });
                return Scaffold(
                  appBar: AppBar(
                    title: Components.defText(text: "Media"),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(40),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: AppColors.secblack,
                          ),
                          child: TabBar(
                            onTap: (value) {
                              print("Tab tapped: $value");
                            },
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: AppColors.grey,
                            tabs: [
                              TabItem(
                                  title: 'Photos', count: cubit.images.length),
                              TabItem(
                                  title: 'Videos', count: cubit.videos.length),
                              TabItem(
                                  title: 'Files', count: cubit.files.length),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  body: TabBarView(children: [
                    state is GetImagesMediaLoading
                        ? Center(
                            child: Components.loadingwidget(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: cubit.images.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 2,
                              ),
                              itemBuilder: (context, index) {
                                return FullScreenWidget(
                                    child: Components.defchachedimg(
                                      "${AppUrl.imagechat}${cubit.images[index].image}",
                                      fit: BoxFit.cover,
                                    ),
                                    disposeLevel: DisposeLevel.Medium);
                              },
                            ),
                          ),
                    state is GetVideosMediaLoading
                        ? Center(
                            child: Components.loadingwidget(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: cubit.videos.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 2,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => VideoPlayerScreen(
                                            url:
                                                "${AppUrl.imagechat}${cubit.videos[index].video}"),
                                        backgroundColor: Colors.transparent);
                                  },
                                  child: VideoGridItem(
                                      chat: false,
                                      videoUrl:
                                          "${AppUrl.imagechat}${cubit.videos[index].video}"),
                                );
                              },
                            ),
                          ),
                    state is GetFilesMediaLoading
                        ? Center(
                            child: Components.loadingwidget(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => AppRoutes.animroutepush(
                                        context: context,
                                        screen: PDFviewScreen({
                                          'link':
                                              "${AppUrl.imagechat}${cubit.files[index].document}",
                                          "name": Stringconstants.formatpdfname(
                                              cubit.files[index].document!)
                                        })),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.secblack),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              MyFlutterApp.file_pdf,
                                              color: AppColors.primary,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Components.defText(
                                              text:
                                                  Stringconstants.formatpdfname(
                                                      cubit.files[index]
                                                          .document!),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 25,
                                  );
                                },
                                itemCount: cubit.files.length),
                          ),
                  ]),
                );
              },
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
