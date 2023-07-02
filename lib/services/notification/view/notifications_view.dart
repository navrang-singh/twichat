import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/appwrite_const.dart';
import 'package:twichat/models/notification_model.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/notification/controllers/notification_controller.dart';
import 'package:twichat/services/notification/widgets/notification_card.dart';
import 'package:twichat/widgets/error_page.dart';
import 'package:twichat/widgets/loading.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConsts.notificationCollectionID}.documents.*.create',
                          )) {
                            final latestNotif =
                                NotificationModel.fromMap(data.payload);
                            if (latestNotif.uid == currentUser.uid) {
                              notifications.insert(0, latestNotif);
                            }
                          } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConsts.notificationCollectionID}.documents.*.delete')) {
                            final latestNotif =
                                NotificationModel.fromMap(data.payload);
                            if (latestNotif.uid == currentUser.uid) {
                              notifications.remove(latestNotif);
                            }
                          }

                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return Notificationcard(
                                notification: notification,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorPage(
                          error: error.toString(),
                        ),
                        loading: () {
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return Notificationcard(
                                notification: notification,
                              );
                            },
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorPage(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
