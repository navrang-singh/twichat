import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twichat/consts/appwrite_const.dart';
import 'package:twichat/consts/appwrite_provider.dart';
import 'package:twichat/consts/failure.dart';
import 'package:twichat/consts/type_def.dart';
import 'package:twichat/models/notification_model.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider3),
  );
});

abstract class INotificationAPI {
  FutureEither<void> createNotification(NotificationModel notification);
  FutureEither<void> deleteNotification(String notificationID);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;
  NotificationAPI({required Databases db, required Realtime realtime})
      : _realtime = realtime,
        _db = db;

  @override
  FutureEither<void> createNotification(NotificationModel notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.notificationCollectionID,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConsts.databaseID,
      collectionId: AppwriteConsts.notificationCollectionID,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConsts.databaseID}.collections.${AppwriteConsts.notificationCollectionID}.documents'
    ]).stream;
  }

  @override
  FutureEither<void> deleteNotification(String notificationID) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.notificationCollectionID,
        documentId: notificationID,
      );
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
