// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twichat/consts/asset_const.dart';
import 'package:twichat/consts/enums/notification_type_enum.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/models/notification_model.dart';
import 'package:twichat/services/notification/controllers/notification_controller.dart';

class Notificationcard extends ConsumerWidget {
  final NotificationModel notification;
  const Notificationcard({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onLongPress() {
      final res = ref.watch(notificationControllerProvider.notifier);
      res.deleteNotification(notificationId: notification.id);
    }

    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: AppColors.blueColor,
            )
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  AssetsConsts.likeFilledIcon,
                  color: AppColors.redColor,
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      AssetsConsts.reShareIcon,
                      color: AppColors.whiteColor,
                      height: 20,
                    )
                  : null,
      title: Text(notification.text),
      onLongPress: onLongPress,
    );
  }
}
