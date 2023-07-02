import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twichat/consts/appwrite_const.dart';
import 'package:twichat/consts/appwrite_provider.dart';
import 'package:twichat/consts/failure.dart';
import 'package:twichat/consts/type_def.dart';
import 'package:twichat/models/user_model.dart';

final userAPIProvider = Provider<UserAPI>((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider2),
  );
});

abstract class IUserAPI {
  FutureEither<void> saveUserData(UserModel userModel);
  FutureEither<void> updateUserData(UserModel userModel, String uid);
  Future<Document> getUserData(String uid);
  Future<List<Document>> getUserbyName(String name);
  Stream<RealtimeMessage> getUserUpdates();
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<void> saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
          Failure(e.message ?? "Some Unexpected error Occurred :( )", st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConsts.databaseID,
      collectionId: AppwriteConsts.userCollectionID,
      documentId: uid,
    );
  }

  @override
  Future<List<Document>> getUserbyName(String name) async {
    final res = await _db.listDocuments(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userCollectionID,
        queries: [
          Query.equal('name', name),
        ]);
    return res.documents;
  }

  @override
  FutureEither<void> updateUserData(UserModel userModel, String uid) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
          Failure(e.message ?? "Some Unexpected error Occurred :( )", st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getUserUpdates() {
    return _realtime.subscribe([
      'databases.${AppwriteConsts.databaseID}.collections.${AppwriteConsts.userCollectionID}.documents',
      'databases.${AppwriteConsts.databaseID}.collections.${AppwriteConsts.userPostCollectionID}.documents',
      'databases.${AppwriteConsts.databaseID}.collections.${AppwriteConsts.notificationCollectionID}.documents',
    ]).stream;
  }
}
