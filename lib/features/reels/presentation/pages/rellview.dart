import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:iclick/features/reels/presentation/widgets/reelitem.dart';

class ReelViewScreen extends StatelessWidget {
  int id;
  ReelViewScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReelsCubit()..getreelbyid(id),
      child: BlocConsumer<ReelsCubit, ReelsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: state is GetReelByIDLoading
                ? Center(
                    child: Components.loadingwidget(),
                  )
                : ReelsItem(
                    ReelsCubit.get(context).reelbyid!, ReelsCubit.get(context)),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
