import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/utils/asset_manger.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplachscreenCubit()..init(context),
      child: BlocConsumer<SplachscreenCubit, SplachscreenState>(
        builder: (context, state) {
          return Scaffold(
            body: Image.asset(
              IMGManger.splash,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
