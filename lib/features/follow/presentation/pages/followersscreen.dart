import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/features/follow/presentation/cubit/follow_cubit.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';

class FollowersScreen extends StatelessWidget {
  String idUser;
  bool isfollowers;
  FollowersScreen(this.idUser, this.isfollowers, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowCubit()..getfollowers(idUser, isfollowers),
      child: BlocConsumer<FollowCubit, FollowState>(
        builder: (context, state) {
          FollowCubit cubit = FollowCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Components.defText(
                  text: isfollowers ? "Followers" : "Following"),
            ),
            body: state is GetFollowersLoading
                ? Center(
                    child: Components.loadingwidget(),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => AppRoutes.animroutepush(
                            context: context,
                            screen: ProfileUserScreen(int.parse(
                                cubit.followers[index].id.toString()))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Components.defchachedimg(
                                  Stringconstants.basicimg(
                                      cubit.followers[index]),
                                  circular: true,
                                  wid: 50,
                                  high: 50),
                              Components.sizedwd(size: 8),
                              Components.defText(
                                  text:
                                      "${cubit.followers[index].firstname} ${cubit.followers[index].lastname}")
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: cubit.followers.length),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
