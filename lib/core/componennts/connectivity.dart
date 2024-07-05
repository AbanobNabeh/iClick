import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/utils/asset_manger.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:lottie/lottie.dart';

Widget isOffline({required Widget widget}) {
  return BlocConsumer<SplachscreenCubit, SplachscreenState>(
    builder: (context, state) {
      return Builder(
        builder: (context) {
          SplachscreenCubit.get(context).checkconnect();
          return SplachscreenCubit.get(context).isconnect ==
                  ConnectivityResult.none
              ? Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(IMGManger.lostconnection),
                      ],
                    ),
                  ),
                )
              : widget;
        },
      );
    },
    listener: (context, state) {},
  );
}
