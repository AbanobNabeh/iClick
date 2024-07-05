import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/addpost/presentation/widgets/editwid.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';

class SearchUserScreen extends StatelessWidget {
  const SearchUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Components.sizedhg(),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          child: Components.defaultform(
                            controller: HomeCubit.get(context).searchusercon,
                            validator: (p0) {},
                            hint: "Search",
                            onChanged: (p0) {
                              HomeCubit.get(context).searchUser(p0);
                            },
                            focusNode: HomeCubit.get(context).searchuserfoc,
                            fouce: false,
                            prefixIcon: MyFlutterApp.search,
                            prefixcolor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Components.sizedhg(),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => AppRoutes.animroutepush(
                                context: context,
                                screen: ProfileUserScreen(HomeCubit.get(context)
                                    .userssearch[index]
                                    .id!)),
                            child: Row(
                              children: [
                                Components.defchachedimg(
                                  raduis: 8,
                                  Stringconstants.basicimg(
                                      HomeCubit.get(context)
                                          .userssearch[index]),
                                  wid: 65,
                                  high: 65,
                                  fit: BoxFit.fill,
                                ),
                                Components.sizedwd(size: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Components.defText(
                                        text:
                                            "${HomeCubit.get(context).userssearch[index].firstname} ${HomeCubit.get(context).userssearch[index].lastname}",
                                        size: 18),
                                    Components.defText(
                                        text:
                                            "@${HomeCubit.get(context).userssearch[index].username}",
                                        size: 16),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                        itemCount: HomeCubit.get(context).userssearch.length)
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
