import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/apis/user_api.dart';
import 'package:twichat/models/user_model.dart';

final searchControllerProvider = StateNotifierProvider((ref) {
  return SearchNotifier(
    userAPI: ref.watch(userAPIProvider),
  );
});

final searchUserControllerProvider =
    FutureProvider.family((ref, String name) async {
  final searchNotifier = ref.watch(searchControllerProvider.notifier);
  return searchNotifier.searchUser(name: name);
});

class SearchNotifier extends StateNotifier<bool> {
  final UserAPI _userAPI;
  SearchNotifier({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser({required String name}) async {
    final usersModels = await _userAPI.getUserbyName(name);
    return usersModels.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
