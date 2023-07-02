import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twichat/consts/appwrite_const.dart';
import 'package:twichat/consts/appwrite_provider.dart';
import 'package:twichat/consts/failure.dart';
import 'package:twichat/consts/type_def.dart';
import 'package:twichat/models/post_model.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(PostModel post);
  Future<List<Document>> getDocuments();
  Stream<RealtimeMessage> getlatestPost();
  FutureEither<Document> likepost(PostModel postModel);
  FutureEither<Document> commentpost(PostModel postModel);
  Future<List<Document>> getComments(List<String> comments);
  Future<Document> getDocumentbyID(String docID);
  Stream<RealtimeMessage> getlatestComment(String postId);
  Future<List<Document>> getUserPosts(String uid);
  // Stream<RealtimeMessage> getlatestUserPost(String postId);
}

class PostAPI implements IPostAPI {
  final Databases _db;
  final Realtime _realtime;
  PostAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
  @override
  FutureEither<Document> sharePost(PostModel post) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userPostCollectionID,
        documentId: ID.unique(),
        data: post.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? "Something went wrong :( ", st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getDocuments() async {
    final ret = await _db.listDocuments(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userPostCollectionID,
        queries: [
          Query.equal('repliedTo', ''),
          Query.orderDesc('postedAt'),
        ]);
    return ret.documents;
  }

  @override
  Stream<RealtimeMessage> getlatestPost() {
    return _realtime.subscribe([
      'databases.${AppwriteConsts.databaseID}.collections.${AppwriteConsts.userPostCollectionID}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likepost(PostModel postModel) async {
    try {
      final ret = await _db.updateDocument(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userPostCollectionID,
        documentId: postModel.id,
        data: {
          'likes': postModel.likes,
        },
      );
      return right(ret);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? "Something went wrong :( ", st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<Document> commentpost(PostModel postModel) async {
    try {
      final ret = await _db.updateDocument(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userPostCollectionID,
        documentId: postModel.id,
        data: {
          'comments': postModel.comments,
        },
      );
      return right(ret);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? "Something went wrong :( ", st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getComments(List<String> comments) async {
    List<Document> docs = [];
    for (String docId in comments) {
      final ret = await getDocumentbyID(docId);
      docs.add(ret);
    }
    docs.sort((a, b) {
      return ((PostModel.fromMap(b.data).postedAt)
          .compareTo(PostModel.fromMap(a.data).postedAt));
    });
    return docs;
  }

  @override
  Future<Document> getDocumentbyID(String docID) async {
    final ret = await _db.getDocument(
      databaseId: AppwriteConsts.databaseID,
      collectionId: AppwriteConsts.userPostCollectionID,
      documentId: docID,
    );
    return ret;
  }

  @override
  Stream<RealtimeMessage> getlatestComment(String postId) {
    return _realtime.subscribe([
      'databases.${AppwriteConsts.databaseID}.collections.${AppwriteConsts.userPostCollectionID}.documents'
    ]).stream;
  }

  @override
  Future<List<Document>> getUserPosts(String uid) async {
    final ret = await _db.listDocuments(
        databaseId: AppwriteConsts.databaseID,
        collectionId: AppwriteConsts.userPostCollectionID,
        queries: [
          Query.equal('uid', uid),
        ]);
    return ret.documents;
  }

  // @override
  // Stream<RealtimeMessage> getlatestUserPost(String postId) {

  // }
}
