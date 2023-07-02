import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twichat/consts/appwrite_provider.dart';
import 'package:twichat/consts/failure.dart';
import 'package:twichat/consts/type_def.dart';

abstract class IAuthApi {
  FutureEither<User> signUp({
    required String email,
    required String name,
    required String password,
  });

  FutureEither<Session> login({
    required String email,
    required String password,
  });

  Future<User?> currentUserAccount();

  FutureEither<void> logout();
}

final authAPIProvider =
    Provider((ref) => AuthApi(account: ref.watch(appwriteAccountProvider)));

class AuthApi implements IAuthApi {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  @override
  FutureEither<User> signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Some error occured :( ", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> login(
      {required String email, required String password}) async {
    try {
      final result = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(result);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? "Some Unexpected Error Occured :(", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<void> logout() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }
}
