import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/features/home/data/models/commentlist.dart';
import 'package:iclick/features/reels/data/models/reelmodel.dart';
import 'package:iclick/features/reels/presentation/cubit/reels_cubit.dart';

Widget bottomcommentshet(ReelModel reels, GlobalKey<FormState> formstate) {
  return BlocProvider(
    create: (context) => ReelsCubit()..getcomment(reels.id.toString()),
    child: BlocConsumer<ReelsCubit, ReelsState>(
      builder: (context, state) {
        ReelsCubit cubit = ReelsCubit.get(context);
        return commentList().comments(
          height: MediaQueryValues(context).height / 1.3,
          addcoment: () => cubit.addcomment(reels.id.toString(), context),
          context: context,
          loading: state is GetCommentLoading,
          isrepaly: cubit.isreplay == null,
          comment: cubit.comments,
          formstate: formstate,
          controller: cubit.commentcon,
          reelsCubit: cubit,
        );
      },
      listener: (context, state) {},
    ),
  );
}
