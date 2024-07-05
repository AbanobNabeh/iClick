import 'package:flutter/material.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/features/chat/presentation/cubit/chat_cubit.dart';

Widget itemprofiledet(ontap, icon, text, leftbutton) => InkWell(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        height: 67,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.grey.withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.white,
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Components.defText(text: text, size: 16),
              ),
              leftbutton == true
                  ? Icon(
                      IconBroken.Arrow___Right_2,
                      color: AppColors.white,
                    )
                  : SizedBox(
                      width: 0,
                    )
            ],
          ),
        ),
      ),
    );

Widget menuMute(
        icon, text, ChatCubit cubit, BuildContext context, String iduser) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.grey.withOpacity(0.1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppColors.white,
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Components.defText(text: text, size: 16),
                ),
                InkWell(
                  onTap: () => cubit.openTimeMute(),
                  child: Icon(
                    IconBroken.Arrow___Down_2,
                    color: AppColors.white,
                  ),
                )
              ],
            ),
            Components.sizedhg(size: 10),
            RadioListTile(
              title: Components.defText(text: "1 Hours"),
              activeColor: AppColors.primary,
              value: 1,
              groupValue: cubit.muteTime,
              onChanged: (value) => cubit.changetimemute(1),
            ),
            RadioListTile(
              title: Components.defText(text: "8 Hour"),
              activeColor: AppColors.primary,
              value: 8,
              groupValue: cubit.muteTime,
              onChanged: (value) => cubit.changetimemute(8),
            ),
            RadioListTile(
              title: Components.defText(text: "3 Days"),
              activeColor: AppColors.primary,
              value: 72,
              groupValue: cubit.muteTime,
              onChanged: (value) => cubit.changetimemute(72),
            ),
            RadioListTile(
              title: Components.defText(text: "2 Weak"),
              activeColor: AppColors.primary,
              value: 336,
              groupValue: cubit.muteTime,
              onChanged: (value) => cubit.changetimemute(336),
            ),
            RadioListTile(
              title: Components.defText(text: "1 month"),
              activeColor: AppColors.primary,
              value: 720,
              groupValue: cubit.muteTime,
              onChanged: (value) => cubit.changetimemute(720),
            ),
            RadioListTile(
              title: Components.defText(text: "Always"),
              activeColor: AppColors.primary,
              value: 8760,
              groupValue: cubit.muteTime,
              onChanged: (value) => cubit.changetimemute(8760),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Components.defButton(
                  text: "Mute",
                  onTap: () => cubit.mutenotification(iduser, context),
                  height: 40),
            ),
          ],
        ),
      ),
    );
