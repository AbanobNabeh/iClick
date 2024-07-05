import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/services/contect_utility.dart';
import 'package:iclick/config/theme/theme.dart';
import 'package:iclick/features/addpost/presentation/cubit/addpost_cubit.dart';
import 'package:iclick/features/follow/presentation/cubit/follow_cubit.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:iclick/features/splachscreen/presentation/pages/splashscreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplachscreenCubit()
            ..notificount()
            ..getprofile()
            ..checkconnect(),
        ),
        BlocProvider(
          create: (context) => AddpostCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit()
            ..getstories()
            ..getposts(),
        ),
        BlocProvider(
          create: (context) => FollowCubit(),
        ),
      ],
      child: BlocConsumer<SplachscreenCubit, SplachscreenState>(
        builder: (context, state) {
          return MaterialApp(
            initialRoute: '/',
            navigatorKey: ContextUtility.navigatorKey,
            routes: {
              '/': (context) => SplashScreen(),
            },
            themeMode: ThemeMode.dark,
            darkTheme: AppTheme.darktheme(),
            debugShowCheckedModeBanner: false,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
