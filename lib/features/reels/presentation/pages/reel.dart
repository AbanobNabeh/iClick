import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:iclick/features/reels/presentation/widgets/reelitem.dart';

class ReelScreen extends StatelessWidget {
  const ReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReelsCubit()
        ..getreel()
        ..scrollLoad(),
      child: BlocConsumer<ReelsCubit, ReelsState>(
        builder: (context, state) {
          ReelsCubit cubit = ReelsCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.black,
            body: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.secblack,
              onRefresh: () async {
                cubit.pageReel = 1;
                cubit.getreel();
              },
              child: SafeArea(
                child: state is GetReelloading
                    ? Center(
                        child: Components.loadingwidget(),
                      )
                    : PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: ReelsCubit.get(context).controller,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ReelsItem(cubit.reels[index], cubit),
                              Visibility(
                                visible: state is LoadReelLoading,
                                child: Positioned(
                                  bottom: 50,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      Components.loadingwidget(),
                                      Components.defText(
                                          text: "Load More Reel",
                                          size: 14,
                                          color: AppColors.secblack)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: cubit.reels.length,
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
